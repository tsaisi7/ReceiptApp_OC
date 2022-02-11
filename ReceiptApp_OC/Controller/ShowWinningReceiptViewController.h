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
//@property (weak, nonatomic) FIRDocumentReference* ref;
//@property (weak, nonatomic) FIRUser* user;
@property NSMutableArray* receipts;
@property NSMutableArray* winningWeceipts;
@property NSMutableArray* winningMoneys;
@property BOOL* isWin;





@end

NS_ASSUME_NONNULL_END
