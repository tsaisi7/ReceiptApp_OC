//
//  ShowReceiptDetailViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/10.
//

#import "ShowReceiptDetailViewController.h"
#import "ShowProductTableViewCell.h"
#import "AddReceiptViewController.h"
@import Firebase;

@interface ShowReceiptDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ShowReceiptDetailViewController

NSMutableArray *receipt;
NSMutableArray *products2;
FIRUser *user4;
FIRDocumentReference *ref4;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user4 = [FIRAuth auth].currentUser;
    ref4 = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user4.uid];
    receipt = [NSMutableArray arrayWithCapacity:8];
    products2 = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self readData];
}

- (void)readData{
    [[[ref4 collectionWithPath:@"Receipts"]documentWithPath:self.receiptID] addSnapshotListener:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        NSLog(@"++++++%@",self.receiptID);
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
            NSString *storeName = snapshot.data[@"storeName"];
            storeName = [storeName isEqual:@""] ? @"商店名稱" : storeName;
            NSString *totalExpense = snapshot.data[@"totalExpense"];
            totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
//            self.storeNameLabel.text = @"TEST";
            self.storeNameLabel.text = storeName;
            self.receipt2NumberLabel.text = snapshot.data[@"receipt2Number"];
            self.receipt8NumberLabel.text = snapshot.data[@"receipt8Number"];
            self.yearLabel.text = snapshot.data[@"year"];
            self.monthLabel.text = snapshot.data[@"month"];
            self.dayLabel.text = snapshot.data[@"day"];
            self.totalExpenseLabel.text = totalExpense;
            
            receipt[0] = storeName;
            receipt[1] = snapshot.data[@"receipt2Number"];
            receipt[2] = snapshot.data[@"receipt8Number"];
            receipt[3] = snapshot.data[@"year"];
            receipt[4] = snapshot.data[@"month"];
            receipt[5] = snapshot.data[@"day"];
            receipt[6] = totalExpense;
            receipt[7] = snapshot.documentID;
        }
    }];
    [[[[ref4 collectionWithPath:@"Receipts"]documentWithPath:self.receiptID]collectionWithPath:@"products"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
            for (FIRDocumentSnapshot *document in snapshot.documents){
                NSMutableArray *product = [NSMutableArray array];
                product[0] = document.data[@"name"];
                product[1] = document.data[@"count"];
                product[2] = document.data[@"amount"];
                product[3] = document.data[@"discount"];
                [products2 addObject:product];
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"editReceipt"]){
        AddReceiptViewController *addReceiptViewController = (AddReceiptViewController*)segue.destinationViewController;
        addReceiptViewController.storeName = receipt[0];
        addReceiptViewController.receipt2Number = receipt[1];
        addReceiptViewController.receipt8Number = receipt[2];
        addReceiptViewController.year = receipt[3];
        addReceiptViewController.month = receipt[4];
        addReceiptViewController.day = receipt[5];
        addReceiptViewController.totalExpense = receipt[6];
        addReceiptViewController.products_add = products2;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"----cell count:%lu", (unsigned long)products2.count);
    return products2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowProductTableViewCell *cell = (ShowProductTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"showProductCell" forIndexPath:indexPath];
    NSMutableArray *product = [products2 objectAtIndex:indexPath.row];
    cell.nameLabel.text = product[0];
    cell.countLabel.text = product[1];
    cell.amountLabel.text = product[2];
    cell.discountLabel.text = product[3];
    return cell;
};

@end
