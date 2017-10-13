//
//  TBRootViewController.m
//  TechBrowser
//
//  Created by Todd Ditchendorf on 11/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TBRootViewController.h"
#import "TBUserDefaults.h"
#import "FUWildcardPattern.h"

@interface TBRootViewController ()
- (void)setUpNavBar;
- (void)setUpBigSpinner;
- (void)updateBigSpinnerFrame;
- (void)killBigSpinner;
//- (void)showReloadBarItem;
//- (void)showActivityBarItem;
@end

@implementation TBRootViewController

- (id)init {
    return [self initWithNibName:@"RootView" bundle:nil];
}


- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)b {
    if (self = [super initWithNibName:name bundle:b]) {
        [self loadDefaultValues];        
    }
    return self;
}


- (void)dealloc {
    self.rootURLString = nil;
    self.rootURLPatterns = nil;
    [super dealloc];
}


- (void)releaseOutlets {
    [self killBigSpinner];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // use standard swipe-from-edge recognizer instead.
    {
        NSAssert(self.navigationController.interactivePopGestureRecognizer, @"");
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [self setUpNavBar];
    [self setUpBigSpinner];

    //    [self showReloadBarItem];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:rootURLString]]];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateBigSpinnerFrame];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


#pragma mark -
#pragma mark Private

- (void)loadDefaultValues {
    self.rootURLString = [[TBUserDefaults instance] rootURLString];
    NSArray *patStrs = [[TBUserDefaults instance] rootURLPatternStrings];
    
    NSMutableArray *pats = [NSMutableArray arrayWithCapacity:[patStrs count]];
    for (NSString *patStr in patStrs) {
        NSAssert([patStr length], @"");
        FUWildcardPattern *pat = [FUWildcardPattern patternWithString:patStr];
        NSAssert(pat, @"");
        if (pat) [pats addObject:pat];
    }
    self.rootURLPatterns = pats; // copies
}


//- (void)showReloadBarItem {
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
//                                                                                            target:self 
//                                                                                            action:@selector(reload:)] autorelease];
//    
//}
//
//
//- (void)showActivityBarItem {
//    CGRect frame = CGRectMake(0, 0, 35, 44);
//    UIView *v = [[[UIView alloc] initWithFrame:frame] autorelease];
//
//    UIImage *img = [[UIImage imageNamed:@"barbuttonitem_plain_bg.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:10];
//    UIImageView *iv = [[[UIImageView alloc] initWithImage:img] autorelease];
//    [iv setAlpha:.8];
//    [iv setFrame:frame];
//    [v addSubview:iv];
//    
//    UIActivityIndicatorView *aiv = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
//    [aiv sizeToFit];
//    frame = [aiv frame];
//    frame.origin.x = 8;
//    frame.origin.y = 12;
//    [aiv setFrame:frame];
//
//    [v addSubview:aiv];
//    [aiv startAnimating];
//
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:v] autorelease];
//}


- (void)showActivityStarted {
    //    [self showActivityBarItem];
}


- (void)showActivityStopped {
    [self killBigSpinner];
    //    [self showReloadBarItem];
}


- (void)updateTitle {
    //    titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


- (void)updateToolbarFrame {
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    CGFloat minY = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    // WEBVIEW
    CGRect webFrame = CGRectMake(0.0, minY, CGRectGetWidth(appFrame), CGRectGetHeight(appFrame));
    [webView setFrame:webFrame];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)type {
    if (UIWebViewNavigationTypeReload == type || UIWebViewNavigationTypeOther == type) {
        return YES;
    }
    
    NSString *URLString = [[req URL] absoluteString];
    
    for (FUWildcardPattern *pat in rootURLPatterns) {
        if ([pat isMatch:URLString]) {
            return YES;
        }
    }
    
    TDBrowserViewController *bvc = [[[TDBrowserViewController alloc] init] autorelease];
    bvc.delegate = self;
    
    // don't use custom gesture recognizer…
//    UISwipeGestureRecognizer *gr = [[[UISwipeGestureRecognizer alloc] initWithTarget:bvc action:@selector(dismiss:)] autorelease];
//    gr.direction = UISwipeGestureRecognizerDirectionRight;
//    [bvc.view addGestureRecognizer:gr];
    
    [self.navigationController pushViewController:bvc animated:YES];
    [bvc loadRequest:req];
    
    return NO;
}


- (void)webViewDidFinishLoad:(UIWebView *)wv {
    [self killBigSpinner];
    [super webViewDidFinishLoad:wv];
}


- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)err {
    [self killBigSpinner];
    [super webView:wv didFailLoadWithError:err];
}


#pragma mark -
#pragma mark TDBrowserViewControllerDelegate

- (void)browserViewControllerDidDismiss:(TDBrowserViewController *)bvc {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Private

- (void)setUpNavBar {
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") 
                                                                              style:UIBarButtonItemStylePlain 
                                                                             target:nil 
                                                                             action:nil] autorelease];
}

- (void)setUpBigSpinner {
    //[self.refreshArrow setHidden:YES];
    self.bigSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [bigSpinner sizeToFit];
    [self.view addSubview:bigSpinner];
    [bigSpinner startAnimating];
}


- (void)updateBigSpinnerFrame {
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect viewBounds = [self.view bounds];
    CGSize spinnerSize = [bigSpinner bounds].size;

    CGRect spinnerFrame = CGRectMake(round(viewBounds.size.width*0.5 - spinnerSize.width*0.5),
                                     round(viewBounds.size.height*0.5 - spinnerSize.height*0.5),
                                     spinnerSize.width, spinnerSize.height);

    [bigSpinner setFrame:spinnerFrame];
}


- (void)killBigSpinner {
    [bigSpinner stopAnimating];
    [bigSpinner removeFromSuperview];
    self.bigSpinner = nil;    
}


#pragma mark -
#pragma mark Notifications

- (void)interfaceOrientationDidChange:(NSNotification *)n {
    [self updateToolbarFrame];
    [self updateBigSpinnerFrame];
    
    UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsValidInterfaceOrientation(orient) && UIInterfaceOrientationIsPortrait(orient)) {
        [webView reload];
    }
}


@synthesize bigSpinner;
@synthesize rootURLString;
@synthesize rootURLPatterns;
@end
