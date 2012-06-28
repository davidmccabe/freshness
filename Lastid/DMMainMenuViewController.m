
#import "DMMainMenuViewController.h"

@implementation DMMainMenuViewController

/*
 The TokenizingViewController has a toolbar, but no other view controllers need one.
 The trouble is, if we hide the toolbar while that viewcontroller is still visible,
 we get a really ugly animation. This is basically a hack to give us a somewhat
 less ugly animation.
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(hideToolbar) withObject:nil afterDelay:0.3];
}

- (void)hideToolbar
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

@end
