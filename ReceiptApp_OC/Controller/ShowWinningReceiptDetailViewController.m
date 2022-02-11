//
//  ShowWinningReceiptDetailViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import "ShowWinningReceiptDetailViewController.h"
#import "ShowWinningProductTableViewCell.h"
#import "Product.h"
@import Firebase;

@interface ShowWinningReceiptDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShowWinningReceiptDetailViewController

FIRUser *user8;
FIRDocumentReference *ref8;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    user8 = [FIRAuth auth].currentUser;
    ref8 = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user8.uid];
    
    self.storeNameLabel.text = self.storeName;
    self.yearLabel.text = self.year;
    self.monthLabel.text = self.month;
    self.dayLabel.text = self.day;
    self.receipt2NumberLabel.text = self.receipt2Number;
    self.receipt8NumberLabel.text = self.receipt8Number;
    self.moneyLabel.text = self.money;
    self.totalExpenseLabel.text = self.totalExpense;
    self.products = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSLog(@"----ID :  %@", self.receiptID);
    [self readProducts];
}

- (void)readProducts{
    [[[[ref8 collectionWithPath:@"Receipts"]documentWithPath:self.receiptID]collectionWithPath:@"products"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        NSLog(@"TESTSTST999");
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
            [self.products removeAllObjects];
            for (FIRDocumentSnapshot *document in snapshot.documents){
                NSLog(@"TESTSTSTSSTS");

                Product *product = [[Product alloc]init];
                product.name = document.data[@"name"];
                product.count = document.data[@"count"];
                product.amount = document.data[@"amount"];
                product.discount = document.data[@"discount"];
                product.productID = document.documentID;
                [self.products addObject:product];

                [self.tableView reloadData];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"----cell count:%lu", (unsigned long)self.products.count);
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowWinningProductTableViewCell *cell = (ShowWinningProductTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"showWinningProductCell" forIndexPath:indexPath];
    Product *product = [self.products objectAtIndex:indexPath.row];
    cell.nameLabel.text = product.name;
    cell.countLabel.text = product.count;
    cell.amountLabel.text = product.amount;
    cell.discountLabel.text = product.discount;
    return cell;
};
@end
