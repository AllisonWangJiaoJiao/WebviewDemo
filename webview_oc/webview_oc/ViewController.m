//
//  ViewController.m
//  webview_oc
//
//  Created by allison on 2021/12/7.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property(nonatomic, strong)WKWebView *webView;
@end

@implementation ViewController

-(WKWebView *)webView {
    if (_webView == nil) {
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //设置是否支持 javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在 iOS 上默认为 NO，表示是否允许不经过用户交互由 javaScript 自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        //这个类主要用来做 native 与 JavaScript 的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个 name 为 jsToOcNoPrams 的 js 方法 设置处理接收 JS 方法的对象
        [wkUController addScriptMessageHandler:self name:@"jsToOcNoPrams"];
        [wkUController addScriptMessageHandler:self name:@"jsToOcWithPrams"];
        config.userContentController = wkUController;
        //用于进行 JavaScript 注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:@"jsBridge" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
        // UI 代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        //此处即需要渲染的网页
        NSString *path = @"http://wxqy.tianjin-air.com/hnatravel/signcodeIOS.html";
        NSURL *url = [NSURL URLWithString:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //NSString *htmlString = [[NSString alloc]initWithContentsOfFile:url encoding:NSUTF8StringEncoding error:nil];
        //[_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        [_webView loadRequest:request];
        
    } return _webView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
}


// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

//提交发生错误时调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

// 接收到服务器跳转请求即服务重定向时之后调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

#pragma mark <WKScriptMessageHandler>
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //此处 message.body 即传给客户端的 json 数据
    //用 message.body 获得 JS 传出的参数体
    NSDictionary * parameter = message.body;
    //JS 调用 OC
    if([message.name isEqualToString:@"jsToOcWithPrams"]){
        //在此处客户端得到 js 透传数据 并对数据进行后续操作
       NSString *params = parameter[@"params"];
       NSString *result = parameter[@"result"];
        NSLog(@"params:%@ , result:%@",params,result);
    }
}

@end
