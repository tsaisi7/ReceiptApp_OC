//
//  LoginViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/7.
//

#import "LoginViewController.h"
@import Firebase;

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (void)alertTitle:(NSString*)title alerMessgae:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];
}
// 實作一個 alertMessage的方法

- (IBAction)login:(id)sender{
    if(self.emailTextField.text && ![self.emailTextField.text  isEqual: @""] && self.passwordTextField.text && ![self.passwordTextField.text isEqual: @""]){
        [[FIRAuth auth] signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error != nil){
                NSLog(@"%@", error.localizedDescription);
                [self alertTitle:@"錯誤" alerMessgae:@"登入失敗"];
            }
            
            if (authResult != nil){
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                [self presentViewController:home animated:YES completion:nil];
            }
        }];
    }else{
        [self alertTitle:@"提醒" alerMessgae:@"請輸入完整資料"];
    }
}
// 實作 login

@end
