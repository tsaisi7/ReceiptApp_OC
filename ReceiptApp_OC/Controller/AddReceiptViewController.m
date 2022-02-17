//
//  AddReceiptViewController.m
//  ReceiptAppself.OC
//
//  Created by CAI SI LIOU on 2022/2/8.
//

#import "AddReceiptViewController.h"
#import "ProductTableViewCell.h"
#import "AddProductViewController.h"
#import "EditProductViewController.h"
#import "Product.h"
#import "Receipt.h"
@import Firebase;

@interface AddReceiptViewController () <AddProductDelegate, EditProductDelegate>


@end

@implementation AddReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.user = [FIRAuth auth].currentUser;
    self.ref = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:self.user.uid];
    self.products = [NSMutableArray array];
    for (Product *product in self.products_add){
        [self.products addObject:product];
    }
    self.IDs = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.storeNameTextField.text = self.storeName;
    self.yearTextField.text = self.year;
    self.monthTextField.text = self.month;
    self.dayTextField.text = self.day;
    self.receipt2NumberTextField.text = self.receipt2Number;
    self.receipt8NumberTextField.text = self.receipt8Number;
    self.totalExpenseTextField.text = self.totalExpense;
    
    [[self.ref collectionWithPath:@"Receipts"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot){
            for (FIRDocumentSnapshot *document in snapshot.documents){
                [self.IDs addObject:document.documentID];
            }
        }
    }];
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (void)alertTitle:(NSString*)title alerMessgae:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)saveReceipt:(id)sender{
    if (![self.receipt2NumberTextField.text isEqual:@""] && ![self.receipt8NumberTextField.text isEqual:@""] && ![self.yearTextField.text isEqual:@""] && ![self.monthTextField.text isEqual:@""] && ![self.dayTextField.text isEqual:@""] && self.storeNameTextField.text && self.receipt2NumberTextField.text && self.receipt8NumberTextField.text && self.yearTextField.text && self.monthTextField.text && self.dayTextField.text && self.totalExpenseTextField.text){

        NSString *receiptID = [[NSString alloc] initWithFormat: @"%@-%@",self.receipt2NumberTextField.text,self.receipt8NumberTextField.text];

        for (NSString *ID in self.IDs){
            NSLog(@"ID: %@",ID);
            if ([ID isEqual:receiptID]){
                [self alertTitle:@"提醒" alerMessgae:@"發票已儲存了"];
                return;
            }
        }
        
        NSDictionary *receiptData = @{
          @"storeName": self.storeNameTextField.text,
          @"receipt2Number": self.receipt2NumberTextField.text,
          @"receipt8Number": self.receipt8NumberTextField.text,
          @"year": self.yearTextField.text,
          @"month": self.monthTextField.text,
          @"day": self.dayTextField.text,
          @"totalExpense": self.totalExpenseTextField.text
        };

        [[[self.ref collectionWithPath:@"Receipts"] documentWithPath:receiptID] setData: receiptData completion:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error writing document: %@", error);
                return;
            }
        }];
        for (Product *product in self.products){
            NSString *productID = [[NSUUID UUID] UUIDString];
            NSDictionary *productData = @{
                @"name": product.name,
                @"count": product.count,
                @"amount": product.amount,
                @"discount": product.discount
            };
            [[[[[self.ref collectionWithPath:@"Receipts"] documentWithPath:receiptID] collectionWithPath:@"products"] documentWithPath:productID] setData:productData completion:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error writing document: %@", error);
                    return;
                }
            }];
        }
        [self alertTitle:@"提醒" alerMessgae:@"發票上傳成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    }
};

- (IBAction)editReceipt:(id)sender{
    NSDictionary *receiptData = @{
      @"storeName": self.storeNameTextField.text,
      @"receipt2Number": self.receipt2NumberTextField.text,
      @"receipt8Number": self.receipt8NumberTextField.text,
      @"year": self.yearTextField.text,
      @"month": self.monthTextField.text,
      @"day": self.dayTextField.text,
      @"totalExpense": self.totalExpenseTextField.text
    };
    
    [[[self.ref collectionWithPath:@"Receipts"] documentWithPath: self.receiptID] updateData:receiptData completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error writing document: %@", error);
            return;
        }
    }];
    for (Product *product in self.products){
        NSString *productID = product.productID == nil ? [[NSUUID UUID] UUIDString] : product.productID;
        NSDictionary *productData = @{
        @"name": product.name,
        @"count": product.count,
        @"amount": product.amount,
        @"discount": product.discount
        };
        if (product.productID == nil) {
            [[[[[self.ref collectionWithPath:@"Receipts"] documentWithPath:self.receiptID] collectionWithPath:@"products"] documentWithPath:productID] setData:productData completion:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error writing document: %@", error);
                    return;
                }
            }];
        }else{
            [[[[[self.ref collectionWithPath:@"Receipts"] documentWithPath:self.receiptID] collectionWithPath:@"products"] documentWithPath:productID] updateData:productData completion:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error writing document: %@", error);
                    return;
                }
            }];
        }
        [self alertTitle:@"提醒" alerMessgae:@"發票編輯成功！"];
    }
    
}

- (void)addProduct:(Product *)product{
    [self.products addObject:product];
    [self.tableView reloadData];

}
// 新增商品 實作AddProductDelegate中的方法

- (void)editProduct:(Product *)product and:(nonnull NSIndexPath *)indexPath{
    self.products[indexPath.row] = product;
    [self.tableView reloadData];
}
// 修改商品 實作EditProductDelegate中的方法

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"addProduct"]){
        AddProductViewController *addProductViewController = segue.destinationViewController;
        addProductViewController.delegate = self;
    }
    if([segue.identifier isEqual: @"editProduct"]){
        EditProductViewController *editProductViewController = segue.destinationViewController;
        editProductViewController.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Product *product = [self.products objectAtIndex:indexPath.row];
        editProductViewController.product = product;
        editProductViewController.indexPath = indexPath;
    }
}
// segue 傳值


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.products.count;
}
// 定義表格數

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductTableViewCell *cell = (ProductTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath: indexPath];
    Product *product = [self.products objectAtIndex:indexPath.row];
    cell.nameTextField.text = product.name;
    cell.countTextField.text = product.count;
    cell.amountTextField.text = product.amount;
    cell.discountTextField.text = product.discount;
    return cell;
}
// 定義表格內容

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Product *product = [self.products objectAtIndex:indexPath.row];
        [[[[[self.ref collectionWithPath:@"Receipts"] documentWithPath:self.receiptID] collectionWithPath:@"products"] documentWithPath:product.productID] deleteDocument];
        [self.products removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        completionHandler(YES);
    }];
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    deleteAction.backgroundColor = UIColor.systemRedColor;
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}
// 實作刪除productCell

@end


