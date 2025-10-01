#include <babylon/system/platform/app_impl.h>
#include <babylon/platform/platform.h>

namespace babylon::system::platform
{

void app_impl::run()
{
    @autoreleasepool
    {
        NSApplication* app = [NSApplication sharedApplication];
        //_delegate = [[app_delegate alloc] init];
        //[app setDelegate:_delegate];
        [app run];
    }

    /*
    @autoreleasepool
    {
        auto context = babylon::system::app::instance().GetPlatformContext<mac::PlatformContext>();
        [NSApplication sharedApplication];
        //context->app_delegate = [[MacAppDelegate alloc] init];
        //[NSApp setDelegate:context->app_delegate];
        [NSApp run];
        //NSApplicationMain(argc, const_cast<const char **>(argv));

        // TODO: Handle return code from exit function
        return 0;
    }
    */
}

} // namespace babylon::system::platform
