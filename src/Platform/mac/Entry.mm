#import <pch.h>

#import <Platform/Entry.h>

#import <System/App.h>
#import <System/AppArguments.h>
#import <Platform/mac/AppDelegate.h>
#import <Platform/mac/PlatformContext.h>

#import <Cocoa/Cocoa.h>

namespace BN::Platform
{

/*
void RunSystemApp()
{
    @autoreleasepool
    {
        [NSApplication sharedApplication];
        SystemAppDelegate *delegate = [[SystemAppDelegate alloc] init];
        [NSApp setDelegate:delegate];


        // Создание окна
        NSRect frame = NSMakeRect(100, 100, 600, 400);
        NSUInteger styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable;
        NSWindow *window = [[NSWindow alloc] initWithContentRect:frame
                                                       styleMask:styleMask
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO];
        [window setTitle:@"Custom Cocoa C++ Loop"];
        [window makeKeyAndOrderFront:nil];
        //[window setDelegate:appDelegate];

        [NSApp run];

        // Кастомный основной цикл
        bool running = true;
        while (running) {
            // Создание и обработка очереди событий
            NSEvent *event;
            while ((event = [NSApp nextEventMatchingMask:NSEventMaskAny
                                               untilDate:nil
                                                  inMode:NSDefaultRunLoopMode
                                                 dequeue:YES])) {
                [NSApp sendEvent:event];
                [NSApp updateWindows];

                // Кастомное условие для завершения работы
                if ([event type] == NSEventTypeKeyDown) {
                    NSString *keyPressed = [event charactersIgnoringModifiers];
                    if ([keyPressed isEqualToString:@"q"]) {
                        running = false;
                        NSLog(@"Exit signal received.");
                    }
                }
            }

            // Пример дополнительной работы в цикле
            std::cout << "Main loop iteration\n";
            usleep(100000); // Задержка для снижения нагрузки на CPU
        }

        // Завершение работы приложения
        [NSApp terminate:nil];
    }
}
*/

std::shared_ptr<IPlatformContext> CreatePlatformContext()
{
    return std::make_shared<Mac::PlatformContext>();
}

int Entry()
{
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
}

} // namespace BN::Platform
