//
//  ShowReceiptViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowReceiptViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *totalExpenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@end

NS_ASSUME_NONNULL_END
