//
//  ShowProductTableViewCell.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;



@end

NS_ASSUME_NONNULL_END
