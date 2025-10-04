#import <babylon/system/platform/mac/bln_loop_controller.h>

@interface bln_loop_controller ()
{
    CVDisplayLinkRef _display_link;
}
@property(nonatomic, copy) dispatch_block_t tick_callback;
@end

static CVReturn display_callback(CVDisplayLinkRef display_link,
                                const CVTimeStamp* now_time,
                                const CVTimeStamp* next_time,
                                CVOptionFlags input_flags,
                                CVOptionFlags* output_flags,
                                void* context)
{
    auto* self = (__bridge bln_loop_controller*)display_link;
    if (!self || !self.tick_callback)
    {
        return kCVReturnSuccess;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.tick_callback();
    });

    return kCVReturnSuccess;
}

@implementation bln_loop_controller

- (instancetype)init:(dispatch_block_t)tick_callback
{
    if ((self = [super init]))
    {
        self.tick_callback = tick_callback;
        CVDisplayLinkCreateWithActiveCGDisplays(&_display_link);
        CVDisplayLinkSetOutputCallback(_display_link, display_callback, (__bridge void*)self);
    }
    return self;
}

- (void)dealloc
{
    [self stop];
    if (_display_link)
    {
        CVDisplayLinkRelease(_display_link);
    }
}

- (void)start
{
    if (_display_link && !CVDisplayLinkIsRunning(_display_link))
    {
        CVDisplayLinkStart(_display_link);
    }
}

- (void)stop
{
    if (_display_link && CVDisplayLinkIsRunning(_display_link))
    {
        CVDisplayLinkStop(_display_link);
    }
}

@end
