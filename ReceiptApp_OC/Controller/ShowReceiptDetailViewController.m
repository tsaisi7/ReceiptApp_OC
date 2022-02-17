//
//  ShowReceiptDetailViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/10.
//

#import "ShowReceiptDetailViewController.h"
#import "ShowProductTableViewCell.h"
#import "AddReceiptViewController.h"
#import "Receipt.h"
#import "Product.h"

@import Firebase;

@interface ShowReceiptDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShowReceiptDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [FIRAuth auth].currentUser;
    self.ref = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:self.user.uid];
    self.receipt = [[Receipt alloc]init];
    self.products = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self readData];
}

- (void)readData{
    [[[self.ref collectionWithPath:@"Receipts"]documentWithPath:self.receiptID] addSnapshotListener:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot){
            NSString *storeName = snapshot.data[@"storeName"];
            storeName = [storeName isEqual:@""] ? @"商店名稱" : storeName;
            NSString *totalExpense = snapshot.data[@"totalExpense"];
            totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
            self.storeNameLabel.text = storeName;
            self.receipt2NumberLabel.text = snapshot.data[@"receipt2Number"];
            self.receipt8NumberLabel.text = snapshot.data[@"receipt8Number"];
            self.yearLabel.text = snapshot.data[@"year"];
            self.monthLabel.text = snapshot.data[@"month"];
            self.dayLabel.text = snapshot.data[@"day"];
            self.totalExpenseLabel.text = totalExpense;
            
            self.receipt.storeName = storeName;
            self.receipt.receipt2Number = snapshot.data[@"receipt2Number"];
            self.receipt.receipt8Number = snapshot.data[@"receipt8Number"];
            self.receipt.year = snapshot.data[@"year"];
            self.receipt.month = snapshot.data[@"month"];
            self.receipt.day = snapshot.data[@"day"];
            self.receipt.totalExpense = totalExpense;
            self.receipt.receiptID = snapshot.documentID;
        }
    }];
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
// 讀取發票及產品

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"editReceipt"]){
        AddReceiptViewController *addReceiptViewController = (AddReceiptViewController*)segue.destinationViewController;
        addReceiptViewController.storeName = self.receipt.storeName;
        addReceiptViewController.receipt2Number = self.receipt.receipt2Number;
        addReceiptViewController.receipt8Number = self.receipt.receipt8Number;
        addReceiptViewController.year = self.receipt.year;
        addReceiptViewController.month = self.receipt.month;
        addReceiptViewController.day = self.receipt.day;
        addReceiptViewController.totalExpense = self.receipt.totalExpense;
        addReceiptViewController.products_add = self.products;
        addReceiptViewController.receiptID = self.receiptID;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowProductTableViewCell *cell = (ShowProductTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"showProductCell" forIndexPath:indexPath];
    Product *product = [self.products objectAtIndex:indexPath.row];
    cell.nameLabel.text = product.name;
    cell.countLabel.text = product.count;
    cell.amountLabel.text = product.amount;
    cell.discountLabel.text = product.discount;
    return cell;
};

@end
