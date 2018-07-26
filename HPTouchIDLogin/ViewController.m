//
//  ViewController.m
//  HPTouchIDLogin
//
//  Created by hupan on 2018/7/26.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginButtonClick:(UIButton *)sender {
    
    //首先判断版本
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        NSLog(@"系统版本不支持TouchID");
        return;
    }
    
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入密码";
    if (@available(iOS 10.0, *)) {
        //        context.localizedCancelTitle = @"22222";
    } else {
        // Fallback on earlier versions
    }
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *message = nil;
                if (success) {
                    message = @"TouchID 验证成功";
                } else if (error){
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:
                            message = @"TouchID 验证失败";
                            break;
                        case LAErrorUserCancel:
                            message = @"TouchID 被用户手动取消";
                            break;
                        case LAErrorUserFallback:
                            message = @"用户不使用TouchID,选择手动输入密码";
                            break;
                        case LAErrorSystemCancel:
                            message = @"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)";
                            break;
                        case LAErrorPasscodeNotSet:
                            message = @"TouchID 无法启动,因为用户没有设置密码";
                            break;
                        case LAErrorTouchIDNotEnrolled:
                            message = @"TouchID 无法启动,因为用户没有设置TouchID";
                            break;
                        case LAErrorTouchIDNotAvailable:
                            message = @"TouchID 无效";
                            break;
                        case LAErrorTouchIDLockout:
                            message = @"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)";
                            break;
                        case LAErrorAppCancel:
                            message = @"当前软件被挂起并取消了授权 (如App进入了后台等)";
                            break;
                        case LAErrorInvalidContext:
                            message = @"当前软件被挂起并取消了授权 (LAContext对象无效)";
                            break;
                        default:
                            break;
                    }
                }
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertController addAction:sure];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }];
        
    }else{
        NSLog(@"当前设备不支持TouchID");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
