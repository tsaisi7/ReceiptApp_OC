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
    // Do any additional setup after loading the view.
}

- (void)alertTitle:(NSString*)title alerMessgae:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)login:(id)sender{
    if(_emailTextField.text != nil && ![_emailTextField.text  isEqual: @""] && _passwordTextField.text != nil && ![_passwordTextField.text isEqual: @""]){
        [[FIRAuth auth] signInWithEmail:self->_emailTextField.text password:self->_passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error != nil){
                NSLog(@"%@", error.localizedDescription);
                [self alertTitle:@"錯誤" alerMessgae:@"登入失敗"];
            }
            
            if (authResult != nil){
                NSLog(@"%@ 登入成功", authResult.user.email);
                [self alertTitle:@"歡迎" alerMessgae:@"登入成功"];
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                [self presentViewController:home animated:YES completion:nil];
            }
        }];
    }else{
        [self alertTitle:@"提醒" alerMessgae:@"請輸入完整資料"];
    }
    
}

@end
