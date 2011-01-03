#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <CFNetwork/CFSocketStream.h>

#import "wax_server.h"
#import "wax.h"
#import "lauxlib.h"

static id gInstance;

static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

@implementation wax_server

@synthesize delegate=_delegate;

+ (id)instance {
	return gInstance;
}

- (void)dealloc { 
    [self stop]; // releases _netService and in/out streams
	gInstance = nil;
    [super dealloc];
}

- (id)init {
	self = [super self];
	if (gInstance) [NSException raise:@"Wax Error" format:@"Wax server has already been created"];
	
	gInstance = self;
	
	return self;
}


- (NSError *)startOnPort:(NSUInteger)port {
	NSError *error = nil;
    CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};
    _ipv4socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&TCPServerAcceptCallBack, &socketCtxt);

    if (_ipv4socket == NULL) {
        error = [[NSError alloc] initWithDomain:@"Wax Error" code:kTCPServerNoSocketsAvailable userInfo:nil];
        _ipv4socket = NULL;
        return NO;
    }	
	
    int yes = 1;
    setsockopt(CFSocketGetNative(_ipv4socket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
	
    // set up the IPv4 endpoint; use port 0, so the kernel will choose an arbitrary port for us, which will be advertised using Bonjour
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    //addr4.sin_port = 0;
	addr4.sin_port = htons(port);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
	
    if (kCFSocketSuccess != CFSocketSetAddress(_ipv4socket, (CFDataRef)address4)) {
        error = [[NSError alloc] initWithDomain:@"Wax Error" code:kTCPServerCouldNotBindToIPv4Address userInfo:nil];
        if (_ipv4socket) CFRelease(_ipv4socket);
        _ipv4socket = NULL;
        return NO;
    }
    
	// now that the binding was successful, we get the port number 
	// -- we will need it for the NSNetService
	NSData *addr = [(NSData *)CFSocketCopyAddress(_ipv4socket) autorelease];
	memcpy(&addr4, [addr bytes], [addr length]);
	
    // set up the run loop sources for the sockets
    CFRunLoopRef cfrl = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _ipv4socket, 0);
    CFRunLoopAddSource(cfrl, source4, kCFRunLoopCommonModes);
    CFRelease(source4);
	
	[self enableBonjourOnPort:port];
		
    return error;
}

- (BOOL)stop {	
	if (_delegate) [_delegate disconnected];
	
    [self disableBonjour];
	
	[_inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[_inStream release];
	_inStream = nil;
	[_outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[_outStream release];
	_outStream = nil;

	if (_ipv4socket) {
		CFSocketInvalidate(_ipv4socket);
		CFRelease(_ipv4socket);
		_ipv4socket = NULL;
	}	
	
    return YES;
}

- (BOOL)send:(NSString *)output {
	if (!_outStream) return NO;
	
	NSInteger length = [_outStream write:(uint8_t *)[output UTF8String] maxLength:[output lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	return length > 0;
}

- (void)receive:(NSData *)data {
	// CTRL-D? Then exit!
	if (data.length == 1 && ((uint8_t *)[data bytes])[0] == 4) {
		uint8_t outputString[] = "Connection Closed";
		[_outStream write:outputString maxLength:NSUIntegerMax];
        NSUInteger port = [_netService port];
		[self stop];
        [self startOnPort:port];
        
		return;
	}
	else if (data.length == 0) { // Who cares!
		return;
	}

	if (_delegate) [_delegate dataReceived:(NSData *)data];
}

- (BOOL)enableBonjourOnPort:(NSUInteger)port {
	NSString *domain = @""; // Will use default Bonjour registration doamins, typically just ".local"
	NSString *name = @""; // Will use default Bonjour name, e.g. the name assigned to the device in iTunes	
	NSString *protocol = [NSString stringWithFormat:@"_%@._tcp.", @"luadebug"];
	
	// First stop existing services
	[self disableBonjour];
	
	_netService = [[NSNetService alloc] initWithDomain:domain type:protocol name:name port:port];
	if (_netService == nil) return NO;
	
	[_netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[_netService publish];
	[_netService setDelegate:self];
	
	return YES;
}

- (void)disableBonjour {
	if (_netService) {
		[_netService stop];
		[_netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		[_netService release];
		_netService = nil;
	}
}

- (void)handleNewConnectionFromAddress:(NSData *)addr inputStream:(NSInputStream *)inStream outputStream:(NSOutputStream *)outStream {	
	if (_inStream || _outStream) {
		[NSException raise:@"Debug Server Error" format:@"Woah, a new connection came in. I have no idea what to do in this situation."];
		return;
	}
	
	_inStream = [inStream retain];
	_inStream.delegate = self;
	[_inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inStream open];
	
	_outStream = [outStream retain];
	_outStream.delegate = self;
	[_outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outStream open];
	
	if (_delegate) [_delegate connected];
}

- (void)netServiceDidPublish:(NSNetService *)sender {
	NSLog(@"Server started on host: %@.local port: %d", [sender name], [sender port]);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {	
	NSLog(@"Bonjour error: %@", errorDict);
}

- (void)netServiceDidStop:(NSNetService *)sender {
	NSLog(@"Server Stopped");
	[self send:@"Server Stopped"];
}

- (NSString*)description {
	return [NSString stringWithFormat:@"<%@ = 0x%08X | port %d | netService = %@>", [self class], (long)self, [_netService port] , _netService];
}

// Stream Delegate
// ---------------
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {
	if (stream != _inStream) return;
	
	switch (streamEvent) {
		case NSStreamEventHasBytesAvailable: {
			uint8_t bytes[1024];
			int length = 0;
			NSMutableData *data = [NSMutableData data];
			while ([_inStream hasBytesAvailable]) {
				length = [_inStream read:bytes maxLength:sizeof(bytes)];
				[data appendBytes:bytes length:length];
			}
			
			[self receive:data];			
			
			break;
		}
			
		case NSStreamEventErrorOccurred:
			NSLog(@"Error: Stream error encountered!");
			break;
	}	
}

@end

// Called by CFSocket when a new connection comes in. Gathers data and calls method on TCPServer.
static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    wax_server *server = (wax_server *)info;
    if (kCFSocketAcceptCallBack == type) { 
        // For an AcceptCallBack, the data parameter is a pointer to a CFSocketNativeHandle
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t namelen = sizeof(name);
        NSData *peer = nil;
        if (0 == getpeername(nativeSocketHandle, (struct sockaddr *)name, &namelen)) {
            peer = [NSData dataWithBytes:name length:namelen];
        }
        CFReadStreamRef readStream = NULL;
		CFWriteStreamRef writeStream = NULL;
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &readStream, &writeStream);
        if (readStream && writeStream) {
            CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            [server handleNewConnectionFromAddress:peer inputStream:(NSInputStream *)readStream outputStream:(NSOutputStream *)writeStream];
        } 
		else {
            // on any failure, need to destroy the CFSocketNativeHandle since we are not going to use it any more
            close(nativeSocketHandle);
        }
        if (readStream) CFRelease(readStream);
        if (writeStream) CFRelease(writeStream);
    }
}

@implementation HACK_WAX_DELEGATE_IMPLEMENTOR
@end
