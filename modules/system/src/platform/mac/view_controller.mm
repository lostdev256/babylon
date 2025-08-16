#import <babylon/platform/mac/view_controller.h>

@implementation view_controller

- (void)loadView
{
    self.view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 700, 450)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _button = [[NSButton alloc] initWithFrame:NSMakeRect(100, 100, 100, 100)];
    [_button setTitle:@"Hello World!"];

    [self.view addSubview:_button];
}

@end
