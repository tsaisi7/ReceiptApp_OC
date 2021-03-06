//
//  ShowReceiptByDateViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/12.
//

#import "ShowReceiptByDateViewController.h"
#import "ShowReceiptDetailViewController.h"
#import "Receipt.h"
#import "ReceiptTableViewCell.h"
@import Firebase;

@interface ShowReceiptByDateViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShowReceiptByDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.receipts = [[NSMutableArray alloc]init];
    self.now = [self.datePicker date];
    self.year = [[NSCalendar currentCalendar]component:NSCalendarUnitYear fromDate:self.now];
    self.month = [[NSCalendar currentCalendar]component:NSCalendarUnitMonth fromDate:self.now];
    self.day = [[NSCalendar currentCalendar]component:NSCalendarUnitDay fromDate:self.now];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.user = [FIRAuth auth].currentUser;
    self.ref = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:self.user.uid];
    
    [self.datePicker addTarget:self action:@selector(updateDate) forControlEvents:UIControlEventValueChanged];
    
}

- (void)updateDate{
    self.now = [self.datePicker date];
    self.year = [[NSCalendar currentCalendar]component:NSCalendarUnitYear fromDate:self.now];
    self.month = [[NSCalendar currentCalendar]component:NSCalendarUnitMonth fromDate:self.now];
    self.day = [[NSCalendar currentCalendar]component:NSCalendarUnitDay fromDate:self.now];
    [self readDataWithYear:self.year month:self.month day:self.day];
}
// 更新時間

- (void)readDataWithYear:(NSInteger)year month:(NSInteger) month day:(NSInteger) day{
    NSString *yearStr = [[NSString alloc]initWithFormat:@"%ld",year-1911];
    NSString *monthStr;
    NSString *dayStr;
    monthStr = month < 10 ? [[NSString alloc]initWithFormat:@"0%ld",month] : [[NSString alloc]initWithFormat:@"%ld",month];
    dayStr = day < 10 ? [[NSString alloc]initWithFormat:@"0%ld",day] : [[NSString alloc]initWithFormat:@"%ld",day];
    
    [[[[[self.ref collectionWithPath:@"Receipts"] queryWhereField:@"year" isEqualTo:yearStr] queryWhereField:@"month" isEqualTo:monthStr] queryWhereField:@"day" isEqualTo:dayStr] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot){
            self.receipts = [NSMutableArray array];
            self.totalExp = 0;
            [self.tableView reloadData];
            self.totalCountLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)self.receipts.count];
            self.totalExpenseLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)self.totalExp];
            
            for (FIRDocumentSnapshot *document in snapshot.documents){
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
                    self.totalExp = self.totalExp + [totalExpense intValue];
                }
                [self.tableView reloadData];
                self.totalCountLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)self.receipts.count];
                self.totalExpenseLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)self.totalExp];
            }
            
        }
    }];
}
//依照日期讀取發票

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"showDetailByDate"]){
        ShowReceiptDetailViewController *showReceiptDetailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Receipt *receipt = self.receipts[indexPath.row];
        showReceiptDetailViewController.receiptID = receipt.receiptID;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.receipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ReceiptTableViewCell *cell = (ReceiptTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"receiptByDateCell" forIndexPath: indexPath];
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
        [[[self.ref collectionWithPath:@"Receipts"]documentWithPath:receipt.receiptID]deleteDocumentWithCompletion:^(NSError * _Nullable error) {
            if (error){
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
