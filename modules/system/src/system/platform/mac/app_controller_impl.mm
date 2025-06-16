#include <pch.h>

#include <System/Platform/Mac/AppControllerImpl.h>

namespace babylon::System
{

    IAppControllerPtr IAppController::CreateImpl()
    {
        return std::make_shared<Platform::AppControllerImpl>();
    }

} // namespace babylon::System

namespace babylon::System::Platform
{

void AppControllerImpl::Control()
{
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        _delegate = [[AppDelegate alloc] init];
        [app setDelegate:_delegate];
        [app run];
    }

    /*
    @autoreleasepool
    {
        auto context = babylon::System::App::Instance().GetPlatformContext<Mac::PlatformContext>();
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

} // namespace babylon::System::Platform
