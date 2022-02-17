//
//  ShowWinningReceiptDetailViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface ShowWinningReceiptDetailViewController : UIViewController

@property (weak , nonatomic) IBOutlet UILabel* storeNameLabel;
@property (weak , nonatomic) IBOutlet UILabel* yearLabel;
@property (weak , nonatomic) IBOutlet UILabel* monthLabel;
@property (weak , nonatomic) IBOutlet UILabel* dayLabel;
@property (weak , nonatomic) IBOutlet UILabel* receipt2NumberLabel;
@property (weak , nonatomic) IBOutlet UILabel* receipt8NumberLabel;
@property (weak , nonatomic) IBOutlet UILabel* totalExpenseLabel;
@property (weak , nonatomic) IBOutlet UITableView* tableView;
@property (weak , nonatomic) IBOutlet UILabel* moneyLabel;
@property (weak , nonatomic) NSString* storeName;
@property (weak , nonatomic) NSString* year;
@property (weak , nonatomic) NSString* month;
@property (weak , nonatomic) NSString* day;
@property (weak , nonatomic) NSString* receipt2Number;
@property (weak , nonatomic) NSString* receipt8Number;
@property (weak , nonatomic) NSString* totalExpense;
@property (weak , nonatomic) NSString* money;
@property (weak , nonatomic) NSString* receiptID;
@property NSMutableArray* products;
@property FIRDocumentReference* ref;
@property FIRUser* user;

@end

NS_ASSUME_NONNULL_END
