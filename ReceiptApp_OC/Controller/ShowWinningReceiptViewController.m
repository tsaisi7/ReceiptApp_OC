//
//  ShowWinningReceiptViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import "ShowWinningReceiptViewController.h"
#import "ShowWinningReceiptDetailViewController.h"
#import "WinningReceiptTableViewCell.h"
#import "Receipt.h"
#import "Product.h"
@import Firebase;

@interface ShowWinningReceiptViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShowWinningReceiptViewController

NSString* monthStr;
NSString* month2Str;
FIRUser* user_winningReceipt;
FIRDocumentReference* ref_winningReceipt;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user_winningReceipt = [FIRAuth auth].currentUser;
    ref_winningReceipt = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user_winningReceipt.uid];
    monthStr = self.month <10 ? [[NSString alloc]initWithFormat:@"0%ld",(long)self.month] :[[NSString alloc]initWithFormat:@"%ld",(long)self.month];
    month2Str = self.month2 <10 ? [[NSString alloc]initWithFormat:@"0%ld",(long)self.month2] :[[NSString alloc]initWithFormat:@"%ld",(long)self.month2];
    self.yearLabel.text = self.year;
    self.monthLabel.text = monthStr;
    self.month2Label.text = month2Str;
    
    self.receipts = [[NSMutableArray alloc]init];
    self.winningReceipts = [[NSMutableArray alloc]init];
    self.winningMoneys = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self readData];
}

- (void)readData{
    [[[[ref_winningReceipt collectionWithPath:@"Receipts"]queryWhereField:@"year" isEqualTo:self.year]queryWhereField:@"month" in:@[monthStr,month2Str]]getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
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
            }
            [self check];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
            });
        }
    }];
}

- (void)winReceipt: (Receipt*) receipt winMoney: (NSString*) money{
    [self.winningReceipts addObject:receipt];
    [self.winningMoneys addObject:money];
    self.isWin = YES;
}
// 加入中獎陣列

- (void)check{
    const char *c = [self.winningNumber UTF8String];
    for(Receipt *receipt in self.receipts){
        NSLog(@"%@",receipt.receipt8Number);
        const char *r = [receipt.receipt8Number UTF8String];
        if (!(c[7] == r[7] && c[6] == r[6])){
            self.isWin = NO;
            NSLog(@"%d",0);
        }else if (!(c[5] == r[5])){
            self.isWin = NO;
            NSLog(@"%d",2);
        }else if (!(c[4] == r[4])){
            NSLog(@"%d",3);
            [self winReceipt:receipt winMoney:@"400"];
        }else if (!(c[3] == r[3])){
            NSLog(@"%d",4);
            [self winReceipt:receipt winMoney:@"1,000"];
        }else if (!(c[2] == r[2])){
            NSLog(@"%d",5);
            [self winReceipt:receipt winMoney:@"4,000"];
        }else if (!(c[1] == r[1])){
            NSLog(@"%d",6);
            [self winReceipt:receipt winMoney:@"10,000"];
        }else if (!(c[0] == r[0])){
            NSLog(@"%d",7);
            [self winReceipt:receipt winMoney:@"40,000"];
        }else{
            NSLog(@"%d",8);
            [self winReceipt:receipt winMoney:@"200,000"];
        }
    }
}
// 兑獎邏輯

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"showWinningReceiptDetail"]){
        NSLog(@"TEST======>");
        ShowWinningReceiptDetailViewController *showWinningReceiptDetailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Receipt *receipt = self.winningReceipts[indexPath.row];
        showWinningReceiptDetailViewController.receiptID = receipt.receiptID;
        showWinningReceiptDetailViewController.money = self.winningMoneys[indexPath.row];
        showWinningReceiptDetailViewController.storeName = receipt.storeName;
        showWinningReceiptDetailViewController.receipt2Number = receipt.receipt2Number;
        showWinningReceiptDetailViewController.receipt8Number = receipt.receipt8Number;
        showWinningReceiptDetailViewController.year = receipt.year;
        showWinningReceiptDetailViewController.month = receipt.month;
        showWinningReceiptDetailViewController.day = receipt.day;
        showWinningReceiptDetailViewController.totalExpense= receipt.totalExpense;
        NSLog(@"receiptID======>%@",receipt.receiptID);
    }
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"----cell count:%lu", (unsigned long)self.winningReceipts.count);
    return self.winningReceipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WinningReceiptTableViewCell *cell = (WinningReceiptTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"winningReceiptCell" forIndexPath: indexPath];
    Receipt *receipt = [self.winningReceipts objectAtIndex:indexPath.row];
    cell.storeNameLabel.text = receipt.storeName;
    cell.receipt2NumberLabel.text = receipt.receipt2Number;
    cell.receipt8NumberLabel.text = receipt.receipt8Number;
    cell.moneyLabel.text = self.winningMoneys[indexPath.row];
    cell.dateLabel.text = [[NSString alloc]initWithFormat:@"%@/%@ ",receipt.month,receipt.day];
    return cell;
}

@end
