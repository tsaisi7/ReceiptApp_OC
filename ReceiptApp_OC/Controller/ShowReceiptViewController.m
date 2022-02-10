//
//  ShowReceiptViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/10.
//

#import "ShowReceiptViewController.h"
#import "Receipt.h"
#import "ReceiptTableViewCell.h"
@import Firebase;

@interface ShowReceiptViewController ()  <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShowReceiptViewController

FIRUser *user3;
FIRDocumentReference *ref3;
NSMutableArray *receipts;
NSInteger *totalExp = 0;
NSMutableArray *dates;
NSDate *now;
NSInteger *year;
NSInteger *month;
NSInteger *day;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    receipts = [[NSMutableArray alloc]init];
    now = [NSDate date];
    year = (NSInteger *)[[NSCalendar currentCalendar]component:NSCalendarUnitYear fromDate:now];
    //    NSLog(@"====YEAR=== %ld",(long)year);
    month = (NSInteger *)[[NSCalendar currentCalendar]component:NSCalendarUnitMonth fromDate:now];
    day = (NSInteger *)[[NSCalendar currentCalendar]component:NSCalendarUnitDay fromDate:now];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    user3 = [FIRAuth auth].currentUser;
    ref3 = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user3.uid];
    
    [self readDateWithYear:year month:month day:day];
}

- (void)readDateWithYear:(NSInteger*)year month:(NSInteger*) month day:(NSInteger*) day{
    NSString *yearStr = [[NSString alloc]initWithFormat:@"%ld",(long)year-1911];
    NSString *monthStr;
    monthStr = (long)month < 10 ? [[NSString alloc]initWithFormat:@"0%ld",(long)month] : [[NSString alloc]initWithFormat:@"%ld",(long)month];
//    NSString *dayStr = [[NSString alloc]initWithFormat:@"%ld",(long)day];
//    NSLog(@"====Year=== %@", yearStr);
//    NSLog(@"====Month=== %@", monthStr);
//    NSLog(@"====Day=== %@", dayStr);
    [[[[ref3 collectionWithPath:@"Receipts"] queryWhereField:@"year" isEqualTo:yearStr] queryWhereField:@"month" isEqualTo:@"01"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
            receipts = [[NSMutableArray alloc]init];
            totalExp = 0;
            self.dateLabel.text = [[NSString alloc]initWithFormat:@"民國 %@ 年 %@ 月",yearStr,monthStr];
            NSLog(@"----------documents.count %lu", (unsigned long)snapshot.documents.count);
            for (FIRDocumentSnapshot *document in snapshot.documents){
                NSString *storeName = document.data[@"storeName"];
                storeName = [storeName isEqual:@""] ? @"商店名稱" : storeName;
                NSString *totalExpense = document.data[@"totalExpense"];
                totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
                NSMutableArray *receiptArray = [NSMutableArray arrayWithCapacity:7];
                receiptArray[0] = storeName;
                receiptArray[1] = document.data[@"receipt2Number"];
                receiptArray[2] = document.data[@"receipt8Number"];
                receiptArray[3] = document.data[@"year"];
                receiptArray[4] = document.data[@"month"];
                receiptArray[5] = document.data[@"day"];
                receiptArray[6] = totalExpense;

                if (receiptArray != nil){
                    [receipts addObject: receiptArray];
                }else{
                    NSLog(@"receiptArray === nil");
                }

//                struct Receipt *receipt;
//                receipt->storeName = storeName;
//                receipt->receipt2Number = document.data[@"receipt2Number"];
//                receipt->receipt8Number = document.data[@"receipt8Number"];
//                receipt->year = document.data[@"year"];
//                receipt->month = document.data[@"month"];
//                receipt->day = document.data[@"day"];
//                receipt->totalExpense = totalExpense;
//                NSValue *receiptVaule;
//                [receiptVaule getValue:&receipt];
//                [receipts addObject:receiptVaule];
                
//                if (![totalExpense isEqual:@"尚未輸入金額"]){
//                    NSLog(@"1receipt totalExp:  %lu",(unsigned long)totalExp);
//                    NSLog(@"2receipt totalExpense:  %lu",(unsigned long)[totalExpense intValue]);
//                    totalExp = totalExp + [totalExpense intValue];
//                    NSLog(@"3receipt totalExp:  %lu",(unsigned long)totalExp);
//
//                }
                
                NSLog(@"====receipt count:%lu",(unsigned long)receipts.count);
                [self.tableView reloadData];
                NSLog(@"receipt count:  %lu",(unsigned long)receipts.count);
                self.totalCountLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)receipts.count];
                self.totalExpenseLabel.text = [[NSString alloc]initWithFormat:@"%lu", (unsigned long)totalExp];
            }
            
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"----cell count:%lu", (unsigned long)receipts.count);
    return receipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ReceiptTableViewCell *cell = (ReceiptTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"receiptCell" forIndexPath: indexPath];
    NSMutableArray *receipt = [receipts objectAtIndex:indexPath.row];

    cell.storeNameLabel.text = receipt[0];
    cell.receipt2NumberLabel.text = receipt[1];
    cell.receipt8NumberLabel.text = receipt[2];
    cell.totalExpenseLabel.text = receipt[6];
    cell.dateLabel.text = [[NSString alloc]initWithFormat:@"%@/%@",receipt[4],receipt[5]];
    return cell;
}

@end
