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

FIRUser *user;
FIRDocumentReference *ref;
NSMutableArray * products;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user = [FIRAuth auth].currentUser;
    ref = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user.uid];
    products = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.storeNameTextField.text = self.storeName;
    self.yearTextField.text = self.year;
    self.monthTextField.text = self.month;
    self.dayTextField.text = self.day;
    self.receipt2NumberTextField.text = self.receipt2Number;
    self.receipt8NumberTextField.text = self.receipt8Number;
    self.totalExpenseTextField.text = self.totalExpense;
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (IBAction)saveReceipt:(id)sender{
    if (![self.receipt2NumberTextField.text isEqual:@""] && ![self.receipt8NumberTextField.text isEqual:@""] && ![self.yearTextField.text isEqual:@""] && ![self.monthTextField.text isEqual:@""] && ![self.dayTextField.text isEqual:@""] && ![self.storeNameTextField.text isEqual:nil] && ![self.receipt2NumberTextField.text isEqual:nil] && ![self.receipt8NumberTextField.text isEqual:nil] && ![self.yearTextField.text isEqual:nil] && ![self.monthTextField.text isEqual:nil] && ![self.dayTextField.text isEqual:nil] && ![self.totalExpenseTextField.text isEqual:nil]){
        
        NSString *receiptID = [[NSString alloc] initWithFormat: @"%@-%@",self.receipt2NumberTextField.text,self.receipt8NumberTextField.text];
        
        NSDictionary *receiptData = @{
          @"storeName": self.storeNameTextField.text,
          @"receipt2Number": self.receipt2NumberTextField.text,
          @"receipt8Number": self.receipt8NumberTextField.text,
          @"year": self.yearTextField.text,
          @"month": self.monthTextField.text,
          @"day": self.dayTextField.text,
          @"totalExpense": self.totalExpenseTextField.text
        };
        
        [[[ref collectionWithPath:@"Receipts"] documentWithPath:receiptID] setData: receiptData completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
                return;
            } else {
                NSLog(@"Receipt successfully uploaded");
            }
        }];
        for (NSValue *product in products){
            NSString *productID = [[NSUUID UUID] UUIDString];
            struct Product product2;
            [product getValue:&product2];
            NSDictionary *productData = @{
            @"name": product2.name,
            @"count": product2.count,
            @"amount": product2.amount,
            @"discount": product2.discount
        };
        [[[[[ref collectionWithPath:@"Receipts"] documentWithPath:receiptID] collectionWithPath:@"products"] documentWithPath:productID] setData:productData completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
                return;
            }else{
                NSLog(@"Product successfully uploaded");
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"發票上傳成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:defaultAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        }
    }
};

- (IBAction)editReceipt:(id)sender{
    
}

- (void)addProduct:(struct Product *)product{
    struct Product product_back;
    product_back.name = product->name;
    product_back.count = product->count;
    product_back.amount = product->amount;
    product_back.discount = product->discount;
    product_back.productID = product->productID;
    NSValue *value = [NSValue valueWithBytes:&product_back objCType:@encode(struct Product)];
    [products addObject:value];
    NSLog(@"----cout:%lu", (unsigned long)[products count]);
    NSLog(@"----products:%@", products);
    [self.tableView reloadData];

}
// 新增商品 實作AddProductDelegate中的方法

- (void)editProduct:(struct Product *)product and:(nonnull NSIndexPath *)indexPath{
    struct Product product_back;
    product_back.name = product->name;
    product_back.count = product->count;
    product_back.amount = product->amount;
    product_back.discount = product->discount;
    product_back.productID = product->productID;
    NSValue *value = [NSValue valueWithBytes:&product_back objCType:@encode(struct Product)];
    products[indexPath.row] = value;
    [self.tableView reloadData];
}
// 修改商品 實作EditProductDelegate中的方法

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"addProduct"]){
        AddProductViewController *addProductViewController = segue.destinationViewController;
        addProductViewController.delegate = self;
        NSLog(@"-----TEST1");
    }
    if([segue.identifier isEqual: @"editProduct"]){
        EditProductViewController *editProductViewController = segue.destinationViewController;
        editProductViewController.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSValue *value = [products objectAtIndex:indexPath.row];
        struct Product product;
        [value getValue:&product];
        NSLog(@"------%@",product.name);
        editProductViewController.product = product;
        editProductViewController.indexPath = indexPath;
    }
}
// segue 傳值


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"----cell count:%lu", (unsigned long)products.count);
    return products.count;
}
// 定義表格數

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductTableViewCell *cell = (ProductTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath: indexPath];
    NSValue *value = [products objectAtIndex:indexPath.row];
    struct Product product;
    [value getValue:&product];
    cell.nameTextField.text = product.name;
    cell.countTextField.text = product.count;
    cell.amountTextField.text = product.amount;
    cell.discountTextField.text = product.discount;
    return cell;
}
// 定義表格內容

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [products removeObjectAtIndex:indexPath.row];
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


