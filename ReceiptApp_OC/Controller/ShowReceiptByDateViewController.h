//
//  ShowReceiptByDateViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowReceiptByDateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UILabel* totalExpenseLabel;
@property (weak, nonatomic) IBOutlet UILabel* totalCountLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker* datePicker;
@property NSMutableArray* receipts;
@property NSDate* now;
@property NSInteger year;
@property NSInteger month;
@property NSInteger day;
@property NSInteger totalExp;



@end

NS_ASSUME_NONNULL_END
