//
//  SignUpViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField* nameTextField;
@property (weak, nonatomic) IBOutlet UITextField* emailTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton* SignUpButton;


@end

NS_ASSUME_NONNULL_END
