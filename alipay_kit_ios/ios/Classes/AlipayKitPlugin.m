#import "AlipayKitPlugin.h"
#import <AFServiceSDK/AFServiceSDK.h>

@implementation AlipayKitPlugin {
    FlutterMethodChannel *_channel;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"v7lin.github.io/alipay_kit"
              binaryMessenger:[registrar messenger]];
    AlipayKitPlugin *instance = [[AlipayKitPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"isInstalled" isEqualToString:call.method]) {
        BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]];
        result([NSNumber numberWithBool:isInstalled]);
    } else if ([@"setEnv" isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
    } else if ([@"pay" isEqualToString:call.method]) {
        result(FlutterMethodNotImplemented);
    } else if ([@"auth" isEqualToString:call.method]) {
        NSString *authInfo = call.arguments[@"authInfo"];
        // NSNumber * isShowLoading = call.arguments[@"isShowLoading"];
//        [[AlipaySDK defaultService] auth_V2WithInfo:authInfo
//                                         fromScheme:scheme
//                                           callback:^(NSDictionary *resultDic) {
//                                               [self->_channel invokeMethod:@"onAuthResp" arguments:resultDic];
//                                           }];
         NSDictionary  *params = @{kAFServiceOptionBizParams: @{
                             @"url":authInfo},
                             kAFServiceOptionCallbackScheme:  @"alipayauthbinding" ,
                             };
        [AFServiceCenter callService:(AFServiceAuth) withParams:params andCompletion:^(AFAuthServiceResponse *response) {
            NSDictionary  *resultDic = @{@"result":response.result};
            [self->_channel invokeMethod:@"onAuthResp" arguments:resultDic];
        }];
//        [AFServiceCenter callService:AFServiceEInvoice withParams:params andCompletion:^(AFServiceResponse *response) {
//            NSLog ( @"%@" , response.result);
//        }];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self handleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"apmqpdispatch"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        __weak typeof(self) weakSelf = self;
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
//                                                  standbyCallback:^(NSDictionary *resultDic) {
//                                                      __strong typeof(weakSelf) strongSelf = weakSelf;
//                                                      [strongSelf->_channel invokeMethod:@"onPayResp" arguments:resultDic];
//                                                  }];
//
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url
//                                         standbyCallback:^(NSDictionary *resultDic) {
//                                             __strong typeof(weakSelf) strongSelf = weakSelf;
//                                             [strongSelf->_channel invokeMethod:@"onAuthResp" arguments:resultDic];
//                                         }];
        [AFServiceCenter handleResponseURL:url withCompletion:^(AFAuthServiceResponse *response) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSDictionary  *resultDic = @{
                                         @"result":response.result
                                        
            };
            [strongSelf->_channel invokeMethod:@"onPayResp" arguments:resultDic];
        }];
//        [AFServiceCenter handleResponseURL:url withCompletion:^(AFServiceResponse *response) {
//                   // 该接口上的block只有在跳转支付宝客户端授权过程中压后台App被系统kill掉时才会被回调
//                   if  (AFResSuccess == response.responseCode) {
//                       NSLog ( @"%@" , response.result);
//                       /* 数据样例
//                      {
//                        "app_id" = 2016051801417322;
//                        "auth_code" = 41f084c3ab4b4be6b6dd8d25dac1YF46;
//                        "result_code" = SUCCESS;
//                        "scope" = auth_user;
//                        "state" = XXXXX（自定义 base64 编码）;
//                      }
//                    */
//                  }
//                }];

        return YES;
    }
    return NO;
}

@end
