//
//  TDPullRefreshBrowserViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "TDPullRefreshBrowserViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0

@interface TDPullRefreshBrowserViewController ()
- (void)setUpPullToRefreshHeader;
- (void)setUpScrollBar;
@end

@implementation TDPullRefreshBrowserViewController

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)b {
    self = [super initWithNibName:name bundle:b];
    if (self) {
        self.textPull = NSLocalizedString(@"Pull down to refresh…", @"");
        self.textRelease = NSLocalizedString(@"Release to refresh…", @"");
        self.textLoading = NSLocalizedString(@"Loading…", @"");
    }
    return self;
}


- (void)dealloc {
    self.refreshHeaderView = nil;
    self.refreshLabel = nil;
    self.refreshArrow = nil;
    self.refreshSpinner = nil;
    self.textPull = nil;
    self.textRelease = nil;
    self.textLoading = nil;
    self.scrollView = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScrollBar];
    [self setUpPullToRefreshHeader];
}


- (void)setUpPullToRefreshHeader {
    CGFloat w = CGRectGetMaxX([[UIScreen mainScreen] bounds]);
    
    self.refreshHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, -REFRESH_HEADER_HEIGHT, w, REFRESH_HEADER_HEIGHT)] autorelease];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.refreshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, w, REFRESH_HEADER_HEIGHT)] autorelease];
    //    refreshLabel.backgroundColor = [UIColor blueColor];
    refreshLabel.textColor = [UIColor colorWithRed:31.0/255.0 green:76.0/255.0 blue:99.0/255.0 alpha:1.0];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.refreshArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
    //    refreshArrow.backgroundColor = [UIColor greenColor];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                    (REFRESH_HEADER_HEIGHT - 44) / 2,
                                    27, 44);

    self.refreshSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    //    refreshSpinner.backgroundColor = [UIColor orangeColor];

    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    //    [self.tableView addSubview:refreshHeaderView];
    [self.scrollView addSubview:refreshHeaderView];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(-[[UIApplication sharedApplication] statusBarFrame].size.height, 0.0, 0.0, 0.0);
}


- (void)setUpScrollBar {
    NSArray *views = [webView subviews];
    for (UIView *v in views) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            //NSLog(@"%@", v);
            self.scrollView = (UIScrollView *)v;
            scrollView.delegate = self;
            //scrollView.backgroundColor = [UIColor yellowColor];
        }
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)sv {
    if (isLoading) return;
    isDragging = YES;
    //self.refreshArrow.hidden = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)sv {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (sv.contentOffset.y > 0) {
            //            self.tableView.contentInset = UIEdgeInsetsZero;
            self.scrollView.contentInset = UIEdgeInsetsZero;
        } else if (sv.contentOffset.y >= -REFRESH_HEADER_HEIGHT) {
            //            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            self.scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    } else if (isDragging && sv.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (sv.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (sv.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}


- (void)startLoading {
    isLoading = YES;

    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    //    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    self.scrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];

    // Refresh action!
    [self refresh];
}


- (void)stopLoading {
    if (!isLoading) return;
    isLoading = NO;

    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    //    self.tableView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}


- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}


- (void)refresh {
    [self reload:nil];
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    //    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}


- (void)loadDidEnd {
    [self stopLoading];
}

@synthesize textPull;
@synthesize textRelease;
@synthesize textLoading;
@synthesize refreshHeaderView;
@synthesize refreshLabel;
@synthesize refreshArrow;
@synthesize refreshSpinner;
@synthesize scrollView;
@end
