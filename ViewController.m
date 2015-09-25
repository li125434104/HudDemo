//
//  ViewController.m
//  HUDDemo
//
//  Created by LXJ on 15/9/21.
//  Copyright © 2015年 GOME. All rights reserved.
//

#import "ViewController.h"
#import "NJKWebViewProgressView.h"
#import "MBProgressHUD.h"
#import "UIViewController+HUD.h"

@interface ViewController ()<MBProgressHUDDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (weak, nonatomic) IBOutlet UIWebView *testWebview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setProgress];
    
    NSString *url = @"http://www.sina.com";
    
    [self loadURL:url];
    
//    [self setHUD];
    
}

- (void)setProgress {
    //创建进度条的代理
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _testWebview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;

    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 2)];
    [self.view addSubview:_progressView];

}

- (void)loadURL:(NSString *)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_testWebview loadRequest:request];
}

#pragma NJKWebviewDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

#pragma 封装的MBHud
-(void)setHUD {
    [self showHudInView:self.view text:@"loading..."];
    [self performSelector:@selector(showSuccess) withObject:nil afterDelay:3.f];
}

- (void)showSuccess {
    [self hideHud];
    [self showHudTextOnlyInView:self.view text:@"加载成功"];
}

- (void)hideHUD {
    [self hideHud];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
