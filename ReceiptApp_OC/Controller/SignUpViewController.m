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
    // Do any additional setup after loading the view.
}

- (IBAction)signUp:(id)sender {
    
    if(_emailTextField.text != nil && ![_emailTextField.text  isEqual: @""] && _passwordTextField.text != nil && ![_passwordTextField.text isEqual: @""]){
        [[FIRAuth auth] createUserWithEmail:_emailTextField.text password:_passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error != nil){
                NSLog(@"%@", error.localizedDescription);
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"註冊失敗" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            if (authResult != nil){
                NSLog(@"%@ 建立成功", authResult.user.email);
                FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                changeRequest.displayName = self->_nameTextField.text;
                [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                    if (error != nil){
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                [self presentViewController:home animated:YES completion:nil];
            }
        }];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"請輸入完整資料" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
