#import <Foundation/Foundation.h>

@class wax_server;

NSString * const TCPServerErrorDomain;

typedef enum {
    kTCPServerCouldNotBindToIPv4Address = 1,
    kTCPServerCouldNotBindToIPv6Address = 2,
    kTCPServerNoSocketsAvailable = 3,
} TCPServerErrorCode;


@protocol WaxServerDelegate

@optional
- (void)connected;
- (void)disconnected;
- (void)dataReceived:(NSData *)data;

@end


#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_2
@interface wax_server : NSObject <NSStreamDelegate, NSNetServiceDelegate> {	
#else
@interface wax_server : NSObject {	
#endif
	CFSocketRef _ipv4socket;
	id<WaxServerDelegate> _delegate;

	NSNetService *_netService;
	NSInputStream *_inStream;
	NSOutputStream *_outStream;
}
	
@property(nonatomic, assign) id<WaxServerDelegate> delegate;

- (NSError *)startOnPort:(NSUInteger)port;
- (BOOL)stop;
- (BOOL)enableBonjourOnPort:(NSUInteger)port;
- (void)disableBonjour;

- (BOOL)send:(NSString *)output;
- (void)receive:(NSData *)output;

@end

// This is needed because the runtime doesn't automatically load protocols
@interface HACK_WAX_DELEGATE_IMPLEMENTOR <WaxServerDelegate> {} 
@end