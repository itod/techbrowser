//
//  TechBrowserAppDelegate.h
//  TechBrowser
//
//  Created by Todd Ditchendorf on 11/21/09.
//  Copyright Todd Ditchendorf 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBRootViewController;

extern NSString * const TDInterfaceOrientationDidChangeNotification;

@interface TBAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navController;
    TBRootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) TBRootViewController *rootViewController;
@end