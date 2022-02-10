//
//  ReceiptTableViewCell.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReceiptTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receipt2NumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *receipt8NumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalExpenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

NS_ASSUME_NONNULL_END
