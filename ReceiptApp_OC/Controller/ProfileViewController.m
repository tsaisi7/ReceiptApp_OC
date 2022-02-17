//
//  ProfileViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/7.
//

#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
@import Firebase;
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nameTextField.text = FIRAuth.auth.currentUser.displayName;
    self.emailTextField.text = FIRAuth.auth.currentUser.email;
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (IBAction)logOut:(id)sender{
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }

    //最開始我是直接用
    //AppDelegate *delgate = (AppDelegate*) UIApplication.sharedApplication.delegate;
    //delegate.window.rootViewController = login;
    //結果 Crash 原因為 AppDelegate 沒有window
    //查到的內容是 在iOS 13以後 window 已經被改到SceneDelegate，我的做法是自己在AppDelegate 實作window 然後取得rootVC，結果不會Crash 但也沒有反應
    //最後的寫法是 改成SceneDelegate
    //然後不能直接用sharedApplication 的delegate
    //而是sharedApplication.connectedScenes.allObjects.firstObject 的delegate
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    SceneDelegate *sceneDelgate = (SceneDelegate*) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    sceneDelgate.window.rootViewController = login;
    //之後可以嘗試 subView
}
//實作logOut

- (IBAction)changeProfile:(id)sender{
    if (![self.emailTextField.text isEqual: @""] && ![self.nameTextField.text  isEqual: @""]){
        if (self.emailTextField.text){
            [[[FIRAuth auth]currentUser] updateEmail:_emailTextField.text completion:^(NSError * _Nullable error) {
                if (!error){
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
        if (self.nameTextField.text){
            FIRUserProfileChangeRequest *changeRequest = [[[FIRAuth auth] currentUser] profileChangeRequest];
            changeRequest.displayName = self->_nameTextField.text;
            [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                if (!error){
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
        if (self.passwordTextField.text){
            [[[FIRAuth auth]currentUser] updatePassword:_passwordTextField.text completion:^(NSError * _Nullable error) {
                if (!error){
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
    }
}
//實作修改會員資料
@end
