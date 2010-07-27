#import <Foundation/Foundation.h>

@class DebugServer;

NSString * const TCPServerErrorDomain;

typedef enum {
    kTCPServerCouldNotBindToIPv4Address = 1,
    kTCPServerCouldNotBindToIPv6Address = 2,
    kTCPServerNoSocketsAvailable = 3,
} TCPServerErrorCode;


@protocol DebugServerDelegate

@optional
- (void)connected;
- (void)disconnected;
- (void)dataReceived:(NSData *)data;

@end


@interface DebugServer : NSObject <NSNetServiceDelegate, NSStreamDelegate> {
    uint16_t _port;
	CFSocketRef _ipv4socket;

	id _delegate;
	
	NSNetService *_netService;
	NSInputStream *_inStream;
	NSOutputStream *_outStream;
}
	
@property(nonatomic, assign) uint16_t port;
@property(nonatomic, assign) id<DebugServerDelegate> delegate;

- (BOOL)start:(NSError **)error;
- (BOOL)stop;
- (BOOL) enableBonjour;
- (void) disableBonjour;

- (BOOL)output:(NSString *)output;

@end
