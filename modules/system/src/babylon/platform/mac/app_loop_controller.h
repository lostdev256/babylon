#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

@interface app_loop_controller : NSObject
- (instancetype)init:(dispatch_block_t)tick_callback;
- (void)start;
- (void)stop;
@end
