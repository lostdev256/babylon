#include <pch.h>

#include <Platform/Apple/Mac/AppController.h>

#import <Platform/Apple/Mac/AppDelegate.h>

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

namespace BN::Platform::Apple::Mac
{

void AppController::Control()
{
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [app setDelegate:delegate];
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

} // namespace BN::Platform::Apple::Mac
