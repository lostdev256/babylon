#include <babylon/system/platform/mac/app_impl.h>

#import <babylon/system/platform/mac/bln_app_delegate.h>

#import <Cocoa/Cocoa.h>

namespace babylon::system::platform
{

bool app_impl::init_impl()
{
    return true;
}

void app_impl::run_impl()
{
    @autoreleasepool
    {
        auto* app = [NSApplication sharedApplication];
        auto* delegate = [[bln_app_delegate alloc] init];
        [app setDelegate:delegate];
        [app setActivationPolicy:NSApplicationActivationPolicyRegular];
        [app run];
    }
}

} // namespace babylon::system::platform
