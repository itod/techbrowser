//
//  TechBrowserAppDelegate.m
//  TechBrowser
//
//  Created by Todd Ditchendorf on 11/21/09.
//  Copyright Todd Ditchendorf 2009. All rights reserved.
//

#import "TBAppDelegate.h"
#import "TBRootViewController.h"

NSString * const TDInterfaceOrientationDidChangeNotification = @"TDInterfaceOrientationDidChange";

@implementation TBAppDelegate

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.window = nil;
    self.navController = nil;
    self.rootViewController = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)app {
    self.rootViewController = [[[TBRootViewController alloc] init] autorelease];
    self.navController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    navController.navigationBarHidden = YES;

    window.rootViewController = navController;
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
}


- (void)application:(UIApplication *)app didChangeStatusBarOrientation:(UIInterfaceOrientation)oldOrientation {
    SEL sel = @selector(postInterfaceOrientationDidChangeNotification);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:sel object:nil];
    [self performSelector:sel withObject:nil afterDelay:0];
}


- (void)postInterfaceOrientationDidChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:TDInterfaceOrientationDidChangeNotification object:nil];
}

@synthesize window;
@synthesize navController;
@synthesize rootViewController;
@end
