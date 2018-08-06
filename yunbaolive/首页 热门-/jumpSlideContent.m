//
//  jumpSlideContent.m
//  yunbaolive
//
//  Created by 志刚杨 on 16/5/21.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "jumpSlideContent.h"
@interface jumpSlideContent ()<UIWebViewDelegate>
{
    int setvisslide;
    UIActivityIndicatorView *testActivityIndicator;
}
@property UILabel *titleLab;

@end

@implementation jumpSlideContent
{
    UIWebView *web;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     这个H5为轮播专用，要求导航透明色没有标题
     */
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0,20+statusbarHeight,_window_width,_window_height-20 - statusbarHeight)];
    NSURLRequest *res = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:self.url]];
    [web loadRequest:res];
    web.delegate = self;
    web.scrollView.bounces = NO;
    [self.view addSubview:web];
    
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    [self navtion];
    if (@available(iOS 11.0,*)) {
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    setvisslide = 1;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    setvisslide = 0;
}
-(void)doReturn{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//设置导航栏标题
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}
-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, 64+statusbarHeight)];
    
    navtion.backgroundColor = [UIColor clearColor];//navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    [self.titleLab setFont:navtionTitleFont];
    self.titleLab.textColor = navtionTitleColor;
    self.titleLab.frame = CGRectMake(30, statusbarHeight,_window_width - 30,84);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    //[navtion addSubview:self.titleLab];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bigBTN];
    returnBtn.frame = CGRectMake(10,30+statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor blackColor];
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [self.view addSubview:btnttttt];
    //[self.view addSubview:navtion];
}
@end
