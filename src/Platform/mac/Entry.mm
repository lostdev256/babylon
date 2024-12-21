#import <pch.h>

#import <Platform/Entry.h>

#import <System/App.h>
#import <System/AppArguments.h>
#import <Platform/mac/AppDelegate.h>

#import <Cocoa/Cocoa.h>

namespace Babylon::Platform
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

#if BABYLON_OS_MAC

int Entry()
{
    @autoreleasepool
    {
        [NSApplication sharedApplication];
        ::AppDelegate *delegate = [[::AppDelegate alloc] init];
        [NSApp setDelegate:delegate];
        [NSApp run];
        //NSApplicationMain(argc, const_cast<const char **>(argv));

        // TODO: Handle return code from exit function
        return 0;
    }
}

#endif

} // namespace Babylon::Platform
