//
//  SuperWebView.m
//  zhangzhihua
//
//  Created by zhangzhihua on 2019/3/6.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//


#import "SuperWebView.h"
#import <WebKit/WebKit.h>

@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>
//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end

@implementation WeakWebViewScriptMessageDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}
#pragma mark - WKScriptMessageHandler
/**
 WKScriptMessageHandler:必须实现的方法，这个方法是提高App与web端交互的关键，它可以直接将接收到的JS脚本转为OC或Swift对象
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}
@end

@interface SuperWebView ()<WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, copy) NSString *webUrl;   //网络url
@property (nonatomic, copy) NSString *loaclUrl;  //本地url
@property (nonatomic, strong) UIProgressView * progressView;  //网页加载进度视图
@property (nonatomic, strong) WKWebView *webView;  //webView实例
@property (nonatomic, strong) NSArray<NSString *> *funcNames;  //注册的方法名
@property (nonatomic, copy) void(^FuncBlock)(NSInteger index,id param); //注册的方法相应的回调

@end

@implementation SuperWebView

#pragma mark - init 初始化方法
+ (instancetype)loadWebUrlWithFrame:(CGRect)frame webUrlAddress:(NSString *)webUrlAddress superView:(nonnull UIView *)superView registerFuncWebToNative:(nullable NSArray<NSString *> *)funcNames eventBlock:(void(^)(NSInteger index,id param))eventBlock{
    SuperWebView *SuperView = [[SuperWebView alloc]initWithFrame:frame webUrl:webUrlAddress localUrlName:nil registerFuncWebToNative:funcNames eventBlock:eventBlock];
    if (superView) {
        [superView addSubview:SuperView];
    }
    return SuperView;
}
+ (instancetype)loadLocalUrlWithFrame:(CGRect)frame localUrlName:(NSString *)localUrlName superView:(nonnull UIView *)superView registerFuncWebToNative:(nullable NSArray<NSString *> *)funcNames eventBlock:(void(^)(NSInteger index,id param))eventBlock{
    SuperWebView *SuperView = [[SuperWebView alloc]initWithFrame:frame webUrl:nil localUrlName:localUrlName registerFuncWebToNative:funcNames eventBlock:eventBlock];
    if (superView) {
        [superView addSubview:SuperView];
    }
    return SuperView;
}
- (instancetype)initWithFrame:(CGRect)frame webUrl:(NSString *)webUrl localUrlName:(NSString *)localUrlName registerFuncWebToNative:(NSArray *)funcNames eventBlock:(void(^)(NSInteger index,id param))eventBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.webUrl = webUrl;
        self.loaclUrl = localUrlName;
        
        if (funcNames) {
            self.funcNames = funcNames;
        }
        if (eventBlock) {
            self.FuncBlock = eventBlock;
        }
        [self addSubview:self.webView];
        [self addSubview:self.progressView];
        
        if (webUrl) {
            [self loadWebUrl:webUrl];
        }
        if (localUrlName) {
            [self loadLocalUrl:localUrlName];
        }
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
#pragma mark - dealloc 内存销毁
- (void)dealloc{
    //移除注册的js方法
    for (NSString *funcStr in self.funcNames) {
        [[_webView configuration].userContentController removeScriptMessageHandlerForName:funcStr];
    }
    //移除观察者
    [_webView removeObserver:self
                  forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self
                  forKeyPath:@"title"];
}
#pragma mark - kvo 监听进度
//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
//        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
                self.progressView.hidden = YES;
                if (self.loadFinishBlock) {
                    self.loadFinishBlock();
                }
            });
        }
        
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
//        [self getViewController].navigationItem.title = _webView.title;
        if (self.titleBlock) {
            self.titleBlock(_webView.title);
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark -- 加载方法
- (void)loadWebUrl:(NSString *)webUrlAddress{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webUrlAddress]];
//    [request addValue:[self readCurrentCookieWithDomain:webUrlAddress] forHTTPHeaderField:@"Cookie"];
    [_webView loadRequest:request];

}
- (void)loadLocalUrl:(NSString *)localUrlName{
    NSString *resourcePath;
    if ([localUrlName hasSuffix:@".html"]) {
        localUrlName = [localUrlName stringByReplacingOccurrencesOfString:@".html" withString:@""];
        resourcePath = [[NSBundle mainBundle] pathForResource:localUrlName ofType:@"html"];
    } else {
        resourcePath = [[NSBundle mainBundle] pathForResource:localUrlName ofType:@"html"];
    }
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

#pragma mark - JS对OC交互


#pragma mark - 通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    //用message.body获得JS传出的参数体
    NSDictionary * parameter = message.body;
    for (int i=0; i<self.funcNames.count; i++) {
        if ([message.name isEqualToString:self.funcNames[i]]) {
            self.FuncBlock(i,parameter);
        }
    }
}
#pragma mark - OC对JS交互
// 原生执行JS脚本调用Web
- (void)evaluateJavaScript:(NSString *)JavaScript completion:(void(^)(id data, NSError * error))completionHandler{
    [_webView evaluateJavaScript:JavaScript completionHandler:^(id data, NSError * error) {
        completionHandler(data,error);
    }];
}
// 原生调用JS方法,可传参数
- (void)evaluateWebFunc:(NSString *)func param:(nullable NSDictionary *)param completion:(void(^)(id data, NSError * error))completionHandler{
    NSString *js;
    if (param) {
        js = [NSString stringWithFormat:@"%@('%@')",func,[self convertToJsonData:param]];
    } else {
        js = [NSString stringWithFormat:@"%@('')",func];
    }
    [self evaluateJavaScript:js completion:^(id  _Nonnull data, NSError * _Nonnull error) {
        completionHandler(data,error);
    }];
}
#pragma mark - 字典转json格式字符串
-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
   //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}

/// webview返回
- (BOOL)webViewCanBack{
    if ([_webView canGoBack]) {
        [_webView goBack];
        NSLog(@"_webView 自己返回了");
        //回调返回web列表的数量
        if (self.backForwardListBlock) {
            self.backForwardListBlock(self.webView.backForwardList.backList.count);
        }
        return YES;
    } else {
        NSLog(@"_webView 返回不了");
        return NO;
    }
}

#pragma mark - WKNavigationDelegate 与页面导航加载代理方法
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self getCookie];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    [self.progressView setProgress:0.0f animated:NO];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    [self.progressView setProgress:0.0f animated:NO];
}

#pragma mark - 页面跳转的代理方法有三种
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
//    NSString * urlStr = navigationAction.request.URL.absoluteString;
    decisionHandler(WKNavigationActionPolicyAllow);
    
    //回调返回web列表的数量
    if (self.backForwardListBlock) {
        self.backForwardListBlock(webView.backForwardList.backList.count);
    }
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
//    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
////    //用户身份信息
//    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
//    //为 challenge 的发送方提供 credential
//    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
//    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,nil);
    
}

//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

#pragma mark - WKUIDelegate 主要处理JS脚本，确认框，警告框等

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
//    [ZhAlertTool showAlertWithTitle:message message:nil cancel:nil sure:nil sureBlock:^{
//        completionHandler();
//    }];
}

/**
 确认框
 JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
//    [ZhAlertTool showAlertWithTitle:message message:nil cancel:@"取消" sure:@"确定" cancelBlock:^{
//        completionHandler(NO);
//    } sureBlock:^{
//        completionHandler(YES);
//    }];
}

/**
 输入框
 JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
//    [AlertView AlertWithTitle:prompt message:@"" placeHolder:@"" input:^(NSString * _Nullable inputStr) {
//        completionHandler(inputStr?:@"");
//    }];
}
/**
 页面是弹出窗口 _blank 处理
 */
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - cookie相关
/**
 解决第一次进入的cookie丢失问题
 */
- (NSString *)readCurrentCookieWithDomain:(NSString *)domainStr{
    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString * cookieString = [[NSMutableString alloc]init];
    for (NSHTTPCookie*cookie in [cookieJar cookies]) {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    
    //删除最后一个“;”
    if ([cookieString hasSuffix:@";"]) {
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    }
    
    return cookieString;
}

//解决 页面内跳转（a标签等）还是取不到cookie的问题
- (void)getCookie{
    
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [_webView evaluateJavaScript:JSCookieString completionHandler:nil];
    
}

#pragma mark - Getter 懒加载

- (UIProgressView *)progressView
{
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
        _progressView.tintColor = [UIColor zh_colorWithHexString:@"#04BE02"];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (WKWebView *)webView{
    
    if(_webView == nil){
        
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.mediaTypesRequiringUserActionForPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        
        //注册js方法 设置处理接收JS方法的对象
        for (NSString *funcStr in self.funcNames) {
            [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:funcStr];
        }
        config.userContentController = wkUController;
        
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        //可返回的页面列表, 存储已打开过的网页
        //       WKBackForwardList * backForwardList = [_webView backForwardList];

    }
    return _webView;
}

#pragma mark - 获取view所在Controller
- (UIViewController *)getViewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}

@end
