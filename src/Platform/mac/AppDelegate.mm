#import <pch.h>

#import <Platform/mac/AppDelegate.h>
#import <Platform/mac/ViewController.h>

#import <System/App.h>

@implementation AppDelegate

-(instancetype)init
{
    self = [super init];
    return self;
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification
{

}

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
    int mask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    _window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 700, 450) styleMask:mask backing:NSBackingStoreBuffered defer:NO];
    _controller = [[ViewController alloc] init];

    [_window.contentView addSubview:_controller.view];

    [_window makeKeyAndOrderFront:nil];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{

}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{

}

- (void)applicationWillResignActive:(NSNotification *)notification
{

}

- (void)applicationDidResignActive:(NSNotification *)notification
{

}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    return NSTerminateLater;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    //[NSApp stop:nil];
    return true;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    //Babylon::System::App::Instance().Teardown();
}

- (void)applicationWillHide:(NSNotification *)notification
{

}

- (void)applicationDidHide:(NSNotification *)notification
{

}

- (void)applicationWillUnhide:(NSNotification *)notification
{
}

- (void)applicationDidUnhide:(NSNotification *)notification
{

}

- (void)applicationWillUpdate:(NSNotification *)notification
{

}

- (void)applicationDidUpdate:(NSNotification *)notification
{
    NSLog(@"UPDATE: %@", notification);
}

- (void)application:(NSApplication *)application didReceiveRemoteNotification:(NSDictionary<NSString *,id> *)userInfo
{

}

@end
