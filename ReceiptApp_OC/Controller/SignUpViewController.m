//
//  SignUpViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/7.
//

#import "SignUpViewController.h"
@import Firebase;

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
// 實作一個alert 方法

- (IBAction)signUp:(id)sender {
    
    if(self.emailTextField.text && ![self.emailTextField.text  isEqual: @""] && self.passwordTextField.text && ![self.passwordTextField.text isEqual: @""]){
        [[FIRAuth auth] createUserWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error){
                NSLog(@"%@", error.localizedDescription);
                [self alertTitle:@"錯誤" alerMessgae:@"註冊失敗"];
            }
            
            if (authResult){
                FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                changeRequest.displayName = self.nameTextField.text;
                [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                    if (error){
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                [self presentViewController:home animated:YES completion:nil];
            }
        }];
    }else{
        [self alertTitle:@"提醒" alerMessgae:@"請輸入完整資料"];
    }
}
// 實作signUp

@end
