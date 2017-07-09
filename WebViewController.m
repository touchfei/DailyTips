//
//  ViewController.m
//  Foundation
//
//  Created by GaoFei on 2017/7/3.
//  Copyright © 2017年 Apple. All rights reserved.
// 模拟webview发送请求

#import "ViewController.h"
#import <WebKit/WebKit.h>


@interface ViewController ()<NSURLSessionDelegate,WKNavigationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self setDateString:@"2016/12/12 18:20"];
    NSURL *url = [NSURL URLWithString:@"http://img1.imgtn.bdimg.com/it/u=142020185,2790987080&fm=26&gp=0.jpg"];
    [self getUrl:url];
//    [self loadWebViewUrl:url];
}


- (void)loadWebViewUrl:(NSURL *)url {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:webView];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    request.HTTPMethod = @"GET";
    
    [webView loadRequest:request];
    webView.navigationDelegate = self;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    NSLog(@"urlString = %@",urlString);
    NSLog(@"request header = %@",[navigationAction.request allHTTPHeaderFields]);
    NSLog(@"request body =%@",[navigationAction.request HTTPBody]);
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    
    
  NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSLog(@"response = %@",response );
    
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"302");
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载");
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"完成加载");
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"加载失败");
}


- (void)getUrl:(NSURL *)url{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    request.HTTPMethod = @"GET";
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_12_4 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12B411" forHTTPHeaderField:@"User-Agent"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSLog(@"request header =%@",[request allHTTPHeaderFields]);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
   NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
       NSLog(@"Response statusCode = %ld",urlResponse.statusCode);
       NSLog(@"Response HeaderFields = %@",urlResponse.allHeaderFields);
       
       NSLog(@"data = %@",data);
       UIImage *image = [UIImage imageWithData:data];
       UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
       imgView.image = image;
       [self.view addSubview:imgView];
       
       
      NSString *dataStr = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
       NSLog(@"dataStr = %@",dataStr);
       
    }];
    [task resume];

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler{
    
    completionHandler(nil);
    
}


- (void)setDateString:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *date = [formatter dateFromString:dateString];
    NSLog(@"date =%@",date);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
