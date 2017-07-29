//
//  TDRootNavigationController.m
//  TechBrowser
//
//  Created by Todd Ditchendorf on 9/29/12.
//
//

#import "TBRootNavigationController.h"

@interface TBRootNavigationController ()

@end

@implementation TBRootNavigationController

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)b {
    self = [super initWithNibName:name bundle:b];
    if (self) {

    }
    return self;
}


- (BOOL)shouldAutorotate {
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
   return UIInterfaceOrientationPortrait;
}

@end
