//
//  ShowReceiptBySearchViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/13.
//

#import <UIKit/UIKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface ShowReceiptBySearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property NSMutableArray* receipts;
@property NSMutableArray* products;
@property NSArray* searchReceipts;
@property BOOL searching;
@property FIRDocumentReference* ref;
@property FIRUser* user;

@end

NS_ASSUME_NONNULL_END
