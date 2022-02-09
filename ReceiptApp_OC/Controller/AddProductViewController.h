//
//  AddProductViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/8.
//

#import <UIKit/UIKit.h>
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddProductDelegate <NSObject>

-(void) addProduct: (struct Product*) product;

@end

@interface AddProductViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) id<AddProductDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
