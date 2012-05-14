//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "DMAppDelegate.h"

@implementation DMAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecordHelpers setupCoreDataStack];

    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"name" forKey:@"inventorySortOrder"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecordHelpers cleanUp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
