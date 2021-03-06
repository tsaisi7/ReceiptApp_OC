//
//  AddReceiptViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/8.
//

#import <UIKit/UIKit.h>
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface AddReceiptViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField* storeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField* yearTextField;
@property (weak, nonatomic) IBOutlet UITextField* monthTextField;
@property (weak, nonatomic) IBOutlet UITextField* dayTextField;
@property (weak, nonatomic) IBOutlet UITextField* receipt2NumberTextField;
@property (weak, nonatomic) IBOutlet UITextField* receipt8NumberTextField;
@property (weak, nonatomic) IBOutlet UITextField* totalExpenseTextField;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) NSString* year;
@property (weak, nonatomic) NSString* month;
@property (weak, nonatomic) NSString* day;
@property (weak, nonatomic) NSString* receipt2Number;
@property (weak, nonatomic) NSString* receipt8Number;
@property (weak, nonatomic) NSString* totalExpense;
@property (weak, nonatomic) NSString* storeName;
@property NSMutableArray* products;
@property NSMutableArray* products_add;
@property (weak, nonatomic) NSString* receiptID;
@property NSMutableArray* IDs;
@property FIRUser* user;
@property FIRDocumentReference* ref;

@end

NS_ASSUME_NONNULL_END


