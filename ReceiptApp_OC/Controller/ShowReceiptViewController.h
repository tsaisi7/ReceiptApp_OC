//
//  ShowReceiptViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/10.
//

#import <UIKit/UIKit.h>
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface ShowReceiptViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;
@property (weak, nonatomic) IBOutlet UIButton* leftButton;
@property (weak, nonatomic) IBOutlet UIButton* rightButton;
@property (weak, nonatomic) IBOutlet UILabel* totalExpenseLabel;
@property (weak, nonatomic) IBOutlet UILabel* totalCountLabel;
@property NSMutableArray* receipts;
@property FIRUser* user;
@property FIRDocumentReference* ref;
@property NSInteger totalExp;
@property NSDate *now;
@property NSInteger year;
@property NSInteger month;
@property NSInteger day;

@end

NS_ASSUME_NONNULL_END
