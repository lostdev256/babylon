#include <babylon/platform/app_impl.h>

#import <babylon/platform/mac/app_delegate.h>

#import <Cocoa/Cocoa.h>

namespace babylon::system::platform
{

void app_impl::run()
{
    @autoreleasepool
    {
        NSApplication* app = [NSApplication sharedApplication];
        app_delegate* delegate = [[app_delegate alloc] init];
        [app setDelegate:delegate];
        [app setActivationPolicy:NSApplicationActivationPolicyRegular];
        [app run];
    }
}

} // namespace babylon::system::platform
