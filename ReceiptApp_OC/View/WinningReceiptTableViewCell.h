//
//  WinningReceiptTableViewCell.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WinningReceiptTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receipt2NumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *receipt8NumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end

NS_ASSUME_NONNULL_END
