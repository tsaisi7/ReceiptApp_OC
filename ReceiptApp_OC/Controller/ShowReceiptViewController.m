//
//  ShowReceiptViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/10.
//

#import "ShowReceiptViewController.h"
#import "Receipt.h"
#import "ReceiptTableViewCell.h"
#import "ShowReceiptDetailViewController.h"
@import Firebase;

@interface ShowReceiptViewController ()  <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShowReceiptViewController

FIRUser *user_showReceipt;
FIRDocumentReference *ref_showReceipt;

NSInteger totalExp = 0;
NSDate *now;
NSInteger year;
NSInteger month;
NSInteger day;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.receipts = [[NSMutableArray alloc]init];
    now = [NSDate date];
    year = [[NSCalendar currentCalendar]component:NSCalendarUnitYear fromDate:now];
    month = [[NSCalendar currentCalendar]component:NSCalendarUnitMonth fromDate:now];
    day = [[NSCalendar currentCalendar]component:NSCalendarUnitDay fromDate:now];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    user_showReceipt = [FIRAuth auth].currentUser;
    ref_showReceipt = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user_showReceipt.uid];
    
    [self readDateWithYear:year month:month day:day];
}

- (IBAction)nextMonth:(id)sender{
    if (month != 12){
        month = month + 1;
        [self readDateWithYear:year month:month day:day];
    }else{
        year = year + 1;
        month = 1;
        [self readDateWithYear:year month:month day:day];

    }
}

- (IBAction)lastMonth:(id)sender{
    if (month != 1){
        month = month - 1;
        [self readDateWithYear:year month:month day:day];

    }else{
        year = year - 1;
        month =  12;
        [self readDateWithYear:year month:month day:day];
    }
}

- (void)readDateWithYear:(NSInteger)year month:(NSInteger) month day:(NSInteger) day{
    NSString *yearStr = [[NSString alloc]initWithFormat:@"%ld",year-1911];
    NSString *monthStr;
    monthStr = month < 10 ? [[NSString alloc]initWithFormat:@"0%ld",month] : [[NSString alloc]initWithFormat:@"%ld",month];
    [[[[ref_showReceipt collectionWithPath:@"Receipts"] queryWhereField:@"year" isEqualTo:yearStr] queryWhereField:@"month" isEqualTo:monthStr] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
            self.receipts = [NSMutableArray array];
            totalExp = 0;
            self.dateLabel.text = [[NSString alloc]initWithFormat:@"民國 %@ 年 %@ 月",yearStr,monthStr];
            NSLog(@"----------documents.count %lu", (unsigned long)snapshot.documents.count);
            NSLog(@"====receipt count:%lu",self.receipts.count);
            [self.tableView reloadData];
            NSLog(@"receipt count:  %lu",(unsigned long)self.receipts.count);
            self.totalCountLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)self.receipts.count];
            self.totalExpenseLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)totalExp];
            
            for (FIRDocumentSnapshot *document in snapshot.documents){
                NSLog(@"-=-=-=-=%@", document.documentID);
                NSString *storeName = document.data[@"storeName"];
                storeName = [storeName isEqual:@""] ? @"商店名稱" : storeName;
                NSString *totalExpense = document.data[@"totalExpense"];
                totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
                Receipt *receipt = [[Receipt alloc] init];
                receipt.storeName = storeName;
                receipt.receipt2Number = document.data[@"receipt2Number"];
                receipt.receipt8Number = document.data[@"receipt8Number"];
                receipt.year = document.data[@"year"];
                receipt.month = document.data[@"month"];
                receipt.day = document.data[@"day"];
                receipt.totalExpense = totalExpense;
                receipt.receiptID = document.documentID;
                [self.receipts addObject: receipt];
                
                if (![totalExpense isEqual:@"尚未輸入金額"]){
                    NSLog(@"1receipt totalExp:  %ld",totalExp);
                    NSLog(@"2receipt totalExpense:  %lu",(unsigned long)[totalExpense intValue]);
                    totalExp = totalExp + [totalExpense intValue];
                    NSLog(@"3receipt totalExp:  %lu",(unsigned long)totalExp);

                }
                
                NSLog(@"====receipt count:%lu",(unsigned long)self.receipts.count);
                [self.tableView reloadData];
                NSLog(@"receipt count:  %lu",(unsigned long)self.receipts.count);
                self.totalCountLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)self.receipts.count];
                self.totalExpenseLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)totalExp];
            }
            
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"showDetail"]){
        ShowReceiptDetailViewController *showReceiptDetailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Receipt *receipt = self.receipts[indexPath.row];
        showReceiptDetailViewController.receiptID = receipt.receiptID;
        NSLog(@"receiptID======>%@",receipt.receiptID);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"----cell count:%lu", (unsigned long)self.receipts.count);
    return self.receipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ReceiptTableViewCell *cell = (ReceiptTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"receiptCell" forIndexPath: indexPath];
    Receipt *receipt = [self.receipts objectAtIndex:indexPath.row];

    cell.storeNameLabel.text = receipt.storeName;
    cell.receipt2NumberLabel.text = receipt.receipt2Number;
    cell.receipt8NumberLabel.text = receipt.receipt8Number;
    cell.totalExpenseLabel.text = receipt.totalExpense;
    cell.dateLabel.text = [[NSString alloc]initWithFormat:@"%@/%@",receipt.month,receipt.day];
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Receipt *receipt = [self.receipts objectAtIndex:indexPath.row];
        [[[ref_showReceipt collectionWithPath:@"Receipts"]documentWithPath:receipt.receiptID]deleteDocumentWithCompletion:^(NSError * _Nullable error) {
            if (error != nil){
                return;
            }
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"發票刪除成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }];
        completionHandler(YES);
    }];
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    deleteAction.backgroundColor = UIColor.systemRedColor;
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}

@end
