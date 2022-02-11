//
//  LoginViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField* emailTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton* loginButton;


@end

NS_ASSUME_NONNULL_END
