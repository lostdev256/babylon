#import <pch.h>

#import <Platform/Apple/Mac/AppDelegate.h>
#import <Platform/Apple/Mac/ViewController.h>

#import <System/App.h>

#import <CoreVideo/CoreVideo.h>
#import <mach/mach_time.h>

@implementation AppDelegate {
    CVDisplayLinkRef displayLink;
    uint64_t start;
}

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
    NSLog(@"Приложение запущено!");

    start = mach_absolute_time();

    // Создаём DisplayLink для обновления на каждом кадре
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    CVDisplayLinkSetOutputCallback(displayLink, &DisplayLinkCallback, (__bridge void *)self);
    CVDisplayLinkStart(displayLink);

    ////////

    int mask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    _window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 700, 450) styleMask:mask backing:NSBackingStoreBuffered defer:NO];
    _controller = [[ViewController alloc] init];

    [_window.contentView addSubview:_controller.view];

    [_window makeKeyAndOrderFront:nil];
}

// Функция, вызываемая на каждом кадре (V-Sync)
static CVReturn DisplayLinkCallback(CVDisplayLinkRef /*displayLink*/,
                                    const CVTimeStamp */*now*/,
                                    const CVTimeStamp */*outputTime*/,
                                    CVOptionFlags /*flagsIn*/,
                                    CVOptionFlags */*flagsOut*/,
                                    void *context) {
    AppDelegate *self = (__bridge AppDelegate *)context;
    [self onFrame];
    return kCVReturnSuccess;
}

- (void)onFrame {

    uint64_t end = mach_absolute_time();

    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    uint64_t elapsedNano = (end - start) * info.numer / info.denom;

    NSLog(@"Время выполнения: %llu наносекунд", elapsedNano);

    //NSLog(@"Frame tick: %@", [NSDate date]);
    start = mach_absolute_time();

}


/*
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
*/

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    //[NSApp stop:nil];
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    CVDisplayLinkStop(displayLink);
    CVDisplayLinkRelease(displayLink);
    //babylon::System::App::Instance().Teardown();
}
/*
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
*/

- (void)applicationDidUpdate:(NSNotification *)notification
{
/*
    uint64_t end = mach_absolute_time();

    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    uint64_t elapsedNano = (end - start) * info.numer / info.denom;

    NSLog(@"Время выполнения: %llu наносекунд", elapsedNano);

    //NSLog(@"Frame tick: %@", [NSDate date]);
    start = mach_absolute_time();
*/
}

/*
- (void)application:(NSApplication *)application didReceiveRemoteNotification:(NSDictionary<NSString *,id> *)userInfo
{

}
*/

@end
