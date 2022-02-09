//
//  EditProductViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import <UIKit/UIKit.h>
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditProductDelegate <NSObject>

-(void) editProduct: (struct Product*) product and: (NSIndexPath*) indexPath;

@end

@interface EditProductViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) id<EditProductDelegate> delegate;
@property struct Product product;
@property (weak, nonatomic) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
