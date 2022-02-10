//
//  ShowReceiptDetailViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowReceiptDetailViewController : UIViewController

@property (weak , nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak , nonatomic) IBOutlet UILabel *yearLabel;
@property (weak , nonatomic) IBOutlet UILabel *monthLabel;
@property (weak , nonatomic) IBOutlet UILabel *dayLabel;
@property (weak , nonatomic) IBOutlet UILabel *receipt2NumberLabel;
@property (weak , nonatomic) IBOutlet UILabel *receipt8NumberLabel;
@property (weak , nonatomic) IBOutlet UILabel *totalExpenseLabel;
@property (weak , nonatomic) IBOutlet UITableView *tableView;
@property (weak , nonatomic) NSString *receiptID;

@end

NS_ASSUME_NONNULL_END