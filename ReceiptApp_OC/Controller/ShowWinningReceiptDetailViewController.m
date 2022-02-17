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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [FIRAuth auth].currentUser;
    self.ref = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:self.user.uid];
    
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
    [self readProducts];
}

- (void)readProducts{
    [[[[self.ref collectionWithPath:@"Receipts"]documentWithPath:self.receiptID]collectionWithPath:@"products"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot){
            [self.products removeAllObjects];
            for (FIRDocumentSnapshot *document in snapshot.documents){
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
// 讀取中獎發票訊息

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
