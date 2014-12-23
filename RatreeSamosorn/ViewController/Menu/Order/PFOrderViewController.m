//
//  PFOrderViewController.m
//  RatreeSamosorn
//
//  Created by Pariwat on 9/2/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFOrderViewController.h"

@interface PFOrderViewController ()

@end

@implementation PFOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.RatreeSamosornApi = [[PFRatreeSamosornApi alloc] init];
    self.RatreeSamosornApi.delegate = self;
    
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"Order";
    } else {
        self.navigationItem.title = @"สั่งซื้อ";
    }
    
    self.token = [self.RatreeSamosornApi getAccessToken];
    self.user_id = [self.RatreeSamosornApi getUserId];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@",@"http://app.pla2.com/rtsms/weborder/index/1/",self.product_id,@"/",self.user_id,@"/",self.token];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:req];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data) {
        [self.NoInternetView removeFromSuperview];
    } else {
        self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
        [self.view addSubview:self.NoInternetView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view addSubview:self.waitView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.waitView removeFromSuperview];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFOrderViewControllerBack)]){
            [self.delegate PFOrderViewControllerBack];
        }
    }
}

@end
