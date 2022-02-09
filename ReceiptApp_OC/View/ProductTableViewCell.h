//
//  ProductTableViewCell.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@end

NS_ASSUME_NONNULL_END
