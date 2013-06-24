//
//  SRPostWebViewController.m
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import "SRPostWebViewController.h"


@interface SRPostWebViewController ()
{
    UIWebView   *_webView;
}

@property (nonatomic, strong)   UIWebView   *webView;

-(void)_layoutViews;

@end

@implementation SRPostWebViewController

@synthesize webView=_webView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURL *url = [NSURL URLWithString:self.feedItem.link];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self _layoutViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.webView=nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self _layoutViews];
}


-(void)_layoutViews
{
    self.webView.frame=self.view.bounds;
}


#pragma mark - Properties -

-(UIWebView*)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_webView];
        _webView.backgroundColor=[UIColor whiteColor];
        [_webView setScalesPageToFit:YES];
    }
    
    return _webView;
}

-(void)setWebView:(UIWebView *)webView
{
    if (!webView)
    {
        [_webView stopLoading];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [_webView removeFromSuperview];
        _webView=nil;
    }
}

@end
