//
//  ShowWinningReceiptViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import <UIKit/UIKit.h>
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface ShowWinningReceiptViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel* yearLabel;
@property (weak, nonatomic) IBOutlet UILabel* monthLabel;
@property (weak, nonatomic) IBOutlet UILabel* month2Label;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) NSString* year;
@property NSInteger month;
@property NSInteger month2;
@property (weak, nonatomic) NSString* winningNumber;
@property FIRDocumentReference* ref;
@property FIRUser* user;
@property NSMutableArray* receipts;
@property NSMutableArray* winningReceipts;
@property NSMutableArray* winningMoneys;
@property BOOL isWin;
@property NSString* monthStr;
@property NSString* month2Str;





@end

NS_ASSUME_NONNULL_END
