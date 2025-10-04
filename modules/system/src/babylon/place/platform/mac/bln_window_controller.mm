#import <babylon/place/platform/mac/bln_window_controller.h>

@implementation bln_window_controller

- (instancetype)initWithInitialContent {
    NSRect frame = NSMakeRect(200, 200, 800, 600);
    NSWindowStyleMask style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
    NSWindow *win = [[NSWindow alloc] initWithContentRect:frame
                                                styleMask:style
                                                  backing:NSBackingStoreBuffered
                                                    defer:NO];
    if ((self = [super initWithWindow:win])) {
//        self.window.title = @"Objective-C++ AppKit Skeleton";
//        self.customView = [CustomView new];
//        self.customView.frame = ((NSView *)win.contentView).bounds;
//        self.customView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
//        win.contentView = self.customView; // control what fills the window
    }
    return self;
}

@end