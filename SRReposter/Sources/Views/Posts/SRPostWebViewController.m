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
    CDFeedItem  *_feedItem;
}

@property (nonatomic)   UIWebView   *webView;

-(void)_layoutViews;

@end

@implementation SRPostWebViewController

@synthesize feedItem=_feedItem;
@synthesize webView=_webView;


- (void)dealloc
{
    self.webView=nil;
    self.feedItem=nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView=nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _layoutViews];
    NSURL *url = [NSURL URLWithString:self.feedItem.link];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
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
