#include <babylon/system/platform/mac/app_controller_impl.h>

namespace babylon::system
{

app_controller_iface_ptr app_controller_iface::create_impl()
{
    return std::make_shared<platform::app_controller_impl>();
}

} // namespace babylon::system

namespace babylon::system::platform
{

void app_controller_impl::control()
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
