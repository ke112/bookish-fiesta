//
//  ZhAuthorizatTool.m
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/28.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//


// 沙盒环境验证
#define kSandboxVerifyUrl @"https://sandbox.itunes.apple.com/verifyReceipt"
// 正式环境验证
#define kReleaseVerifyUrl @"https://buy.itunes.apple.com/verifyReceipt"


#import <StoreKit/StoreKit.h>
#import "ZHIAPHelper.h"

//内购恢复过程
typedef NS_ENUM(NSInteger, ENUMRestoreProgress) {
    ENUMRestoreProgressStop = 0,                // 尚未开始请求
    ENUMRestoreProgressStart = 1,               // 开始请求
    ENUMRestoreProgressUpdatedTransactions = 2, // 更新了事务
    ENUMRestoreProgressFinish = 3,              // 完成请求
};

@interface ZHIAPHelper () <SKPaymentTransactionObserver, SKProductsRequestDelegate> {
    NSString *_productId;
    IAPCompletionHandle _handle;
}

// 判断一份交易获得验证的次数  key为随机值
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *transactionCountMap;
// 需要验证的支付事务
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSMutableSet<SKPaymentTransaction *> *> *transactionFinishMap;

@property(nonatomic, assign) ENUMRestoreProgress restoreProgress;

@end

@implementation ZHIAPHelper

+ (instancetype)sharedInstance {
    static ZHIAPHelper *_IAPInstabce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _IAPInstabce = [[ZHIAPHelper alloc] init];
    });
    return _IAPInstabce;
}

- (instancetype)init {
    if (self = [super init]) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [self addTransactionObserver];
    }
    return self;
}

- (void)dealloc {
    [self removeTransactionObserver];
}

- (void)addTransactionObserver {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)removeTransactionObserver {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - public method
// 购买
- (void)startPurchaseWithProductId:(NSString * _Nonnull)productId completeHandle:(IAPCompletionHandle _Nullable)handle {
    [self startSubscribeWithProductId:productId password:nil completeHandle:handle];
}

// 订阅
- (void)startSubscribeWithProductId:(NSString * _Nonnull)productId password:(NSString * _Nullable)password completeHandle:(IAPCompletionHandle _Nullable)handle {
    if (!productId) {
        [self handleActionWithType:IAPPurchEmptyID data:nil];
        return;
    }
    
    if (![SKPaymentQueue canMakePayments]) {
        [self handleActionWithType:IAPPurchNotAllow data:nil];
        return;
    }
    
    _productId = productId;
    _password = password;
    _handle = handle;
    NSSet *set = [NSSet setWithArray:@[productId]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

#pragma mark - SKProductsRequestDelegate
//发送请求后 会回调  执行这个方法
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    if ([products count] <= 0) {
        KKLog(@"--------------没有商品------------------");
        [self handleActionWithType:IAPPurchNoProduct data:nil];
        return;
    }
    
    SKProduct *p = nil;
    for (SKProduct *pro in products) {
        if ([pro.productIdentifier isEqualToString:_productId]) {
            p = pro;
            break;
        }
    }
    
    
    KKLog(@"productID:%@", response.invalidProductIdentifiers);
    KKLog(@"产品付费数量:%lu", (unsigned long) [products count]);
    KKLog(@"%@", [p description]);
    KKLog(@"%@", [p localizedTitle]);
    KKLog(@"%@", [p localizedDescription]);
    KKLog(@"%@", [p price]);
    KKLog(@"%@", [p productIdentifier]);
    KKLog(@"发送购买请求");
    
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}



// 恢复购买
- (void)restorePurchasesWithCompleteHandle:(IAPCompletionHandle)handle {
    //开始恢复
    _restoreProgress = ENUMRestoreProgressStart;
    _handle = handle;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - SKPaymentTransactionObserver
// 队列操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    //判断是否为恢复购买的请求
    if (_restoreProgress == ENUMRestoreProgressStart) {
        _restoreProgress = ENUMRestoreProgressUpdatedTransactions;
    }
    
    NSString *operationId = [[NSUUID UUID] UUIDString];
    
    [self.transactionFinishMap setValue:[NSMutableSet set] forKey:operationId];
    [self.transactionCountMap setValue:@(transactions.count) forKey:operationId];
    
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self completeTransaction:tran operationId:operationId];
            } break;
            case SKPaymentTransactionStatePurchasing:{
                KKLog(@"正在购买");
            } break;
            case SKPaymentTransactionStateRestored:{
                KKLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self restoreTransaction:tran operationId:operationId];
            } break;
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self failedTransaction:tran];
            } break;
            default:
                break;
        }
    }
}

// 恢复购买结束回调
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    // 没有进入- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions 方法
    // 恢复产品数量为0  提前结束
    if(_restoreProgress != ENUMRestoreProgressUpdatedTransactions){
        [self handleActionWithType:IAPPurchRestoreNotBuy data:nil];
    }
    _restoreProgress = ENUMRestoreProgressFinish;
}

// 恢复购买失败
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    //恢复失败
    if(_restoreProgress != ENUMRestoreProgressUpdatedTransactions){
        [self handleActionWithType:IAPPurchRestoreFailed data:@{@"error":error.localizedDescription}];
    }
    _restoreProgress = ENUMRestoreProgressFinish;
    
}


#pragma mark - transaction action
// 恢复购买
- (void)restoreTransaction:(SKPaymentTransaction *)transaction operationId:(NSString *)operationId {
    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO operationId:operationId];
}

// 完成交易
- (void)completeTransaction:(SKPaymentTransaction *)transaction operationId:(NSString *)operationId {
    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO operationId:operationId];
}

// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:IAPPurchFailed data:@{@"error":transaction.error.localizedDescription}];
    } else {
        [self handleActionWithType:IAPPurchCancle data:nil];
    }
}

// 交易验证
- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag operationId:(NSString *)operationId {
    
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if (!receipt) {
        // 交易凭证为空验证失败
        [self handleActionWithType:IAPPurchVerFailed data:nil];
        return;
    }
    
    NSDictionary *receiptDict = [NSJSONSerialization JSONObjectWithData:receipt options:0 error:nil];
    // 购买成功将交易凭证发送给服务端进行再次校验
    [self handleActionWithType:IAPPurchSuccess data:receiptDict];
    
    NSError *error;
    NSDictionary *requestContents;
    if (_password) {
        requestContents = @{@"receipt-data": [receipt base64EncodedStringWithOptions:0], @"password":_password};
    } else {
        requestContents = @{@"receipt-data": [receipt base64EncodedStringWithOptions:0]};
    }
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    
    // 交易凭证为空验证失败
    if (!requestData) {
        [self handleActionWithType:IAPPurchVerFailed data:nil];
        return;
    }
    
    NSString *serverString;
    if (flag) {
        serverString = kSandboxVerifyUrl;
    } else {
        serverString = kReleaseVerifyUrl;
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            // 无法连接服务器,购买校验失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleActionWithType:IAPPurchVerFailed data:nil];
            });
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                // 苹果服务器校验数据返回为空校验失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleActionWithType:IAPPurchVerFailed data:nil];
                });
            }
            
            /****************************************************************************
             验证错误状态码:
             -> 21000 App Store无法读取你提供的JSON数据
             -> 21002 收据数据不符合格式
             -> 21003 收据无法被验证
             -> 21004 你提供的共享密钥和账户的共享密钥不一致
             -> 21005 收据服务器当前不可用
             -> 21006 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
             -> 21007 收据信息是测试用（sandbox），但却被发送到产品环境中验证
             -> 21008 收据信息是产品环境中使用，但却被发送到测试环境中验证
             ****************************************************************************/
            
            // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
            NSString *status = [NSString stringWithFormat:@"%@", jsonResponse[@"status"]];
            
            if (status && [status isEqualToString:@"21007"]) {
                // 转沙盒验证
                [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES operationId:operationId];
                
            } else if (status && [status isEqualToString:@"0"]) {
                // 订单校验成功
                // APP添加商品
                NSString *productId = transaction.payment.productIdentifier;
                KKLog(@"\n\n===============>> 购买成功ID:%@ <<===============\n\n",productId);
                // 订单总数量
                NSInteger totalCount = [[self.transactionCountMap valueForKey:operationId] integerValue];
                // 已执行数量
                NSMutableSet *finishSet = [self.transactionFinishMap valueForKey:operationId];
                [finishSet addObject:transaction];
                // 需在添加对象后获得对象数量 不然有极低的可能遇到并发问题 而导致不执行回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleActionWithType:IAPPurchVerSuccess data:jsonResponse invokeHandle:[finishSet count]  == totalCount];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleActionWithType:IAPPurchVerFailed data:nil];
                });
            }
            KKLog(@"----验证结果 %@", jsonResponse);
        }
    }];
    
    [task resume];
}



//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self handleActionWithType:IAPPurchFailed data:@{@"error":error.localizedDescription}];
    KKLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request {
    KKLog(@"------------反馈信息结束-----------------");
}


#pragma mark - private method

//适配器模式
- (void)handleActionWithType:(IAPPurchType)type data:(NSDictionary *)dict invokeHandle:(Boolean)invoke {
    
#ifdef DEBUG
    switch (type) {
        case IAPPurchSuccess:
            KKLog(@"购买成功");
            break;
        case IAPPurchFailed:
            KKLog(@"购买失败");
            break;
        case IAPPurchCancle:
            KKLog(@"用户取消购买");
            break;
        case IAPPurchVerFailed:
            KKLog(@"订单校验失败");
            break;
        case IAPPurchVerSuccess:
            KKLog(@"订单校验成功");
            break;
        case IAPPurchNotAllow:
            KKLog(@"不允许程序内付费");
            break;
        case IAPPurchRestoreNotBuy:
            KKLog(@"购买数量为0");
            break;
        case IAPPurchRestoreFailed:
            KKLog(@"内购恢复失败");
            break;
        case IAPPurchEmptyID:
            KKLog(@"商品ID为空");
            break;
        case IAPPurchNoProduct:
            KKLog(@"没有可购买商品");
            break;
        default:
            break;
    }
#endif
    
    //因为购买成功并不是最后一个步骤 没有意义 不进行处理,需要完成验证
    if (type == IAPPurchSuccess) {
        return;
    }
    
    if (invoke && _handle) {
        _handle(type, dict);
    }
}

//完成回调 自己的block
- (void)handleActionWithType:(IAPPurchType)type data:(NSDictionary *)dict {
    [self handleActionWithType:type data:dict invokeHandle:true];
}

#pragma mark - getter & setter
- (NSMutableDictionary *)transactionFinishMap {
    if (!_transactionFinishMap) {
        _transactionFinishMap = [NSMutableDictionary dictionary];
    }
    return _transactionFinishMap;
}


- (NSMutableDictionary *)transactionCountMap {
    if (!_transactionCountMap) {
        _transactionCountMap = [NSMutableDictionary dictionary];
    }
    return _transactionCountMap;
}



@end
