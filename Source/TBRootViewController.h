//
//  TBRootViewController.h
//  TechBrowser
//
//  Created by Todd Ditchendorf on 11/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDPullRefreshBrowserViewController.h"

@interface TBRootViewController : TDPullRefreshBrowserViewController <TDBrowserViewControllerDelegate> {
    UIActivityIndicatorView *bigSpinner;
    NSString *rootURLString;
    NSArray *rootURLPatterns;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *bigSpinner;
@property (nonatomic, copy) NSString *rootURLString;
@property (nonatomic, copy) NSArray *rootURLPatterns;
@end
