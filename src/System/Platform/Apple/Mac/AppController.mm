#include <pch.h>

#include <System/Platform/Apple/Mac/AppController.h>

namespace BN::System
{

    IAppControllerPtr IAppController::Create()
    {
        return std::make_shared<Platform::AppController>();
    }

} // namespace BN::System

namespace BN::System::Platform
{

void AppController::Control()
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
        auto context = BN::System::App::Instance().GetPlatformContext<Mac::PlatformContext>();
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

} // namespace BN::System::Platform
