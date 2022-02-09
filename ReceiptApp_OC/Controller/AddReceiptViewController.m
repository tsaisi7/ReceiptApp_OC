//
//  AddReceiptViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/8.
//

#import "AddReceiptViewController.h"
#import "ProductTableViewCell.h"
#import "AddProductViewController.h"
#import "EditProductViewController.h"
#import "Product.h"
#import "Receipt.h"


@interface AddReceiptViewController () <AddProductDelegate, EditProductDelegate>


@end

@implementation AddReceiptViewController

NSMutableArray *products;
NSMutableArray *receipts;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    products = [NSMutableArray arrayWithCapacity:0];
    receipts = [NSMutableArray arrayWithCapacity:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _yearTextField.text = _year;
    _monthTextField.text = _month;
    _dayTextField.text = _day;
    _receipt2NumberTextField.text = _receipt2Number;
    _receipt8NumberTextField.text = _receipt8Number;
    _totalExpenseTextField.text = _totalExpense;
}

- (IBAction)saveReceipt:(id)sender{
    if (![_storeNameTextField.text isEqual:@""] && ![_receipt2NumberTextField.text isEqual:@""] && ![_receipt8NumberTextField.text isEqual:@""] && ![_yearTextField.text isEqual:@""] && ![_monthTextField.text isEqual:@""] && ![_dayTextField.text isEqual:@""] && ![_totalExpenseTextField.text isEqual:@""] && ![_storeNameTextField.text isEqual:nil] && ![_receipt2NumberTextField.text isEqual:nil] && ![_receipt8NumberTextField.text isEqual:nil] && ![_yearTextField.text isEqual:nil] && ![_monthTextField.text isEqual:nil] && ![_dayTextField.text isEqual:nil] && ![_totalExpenseTextField.text isEqual:nil]){
        
        struct Receipt receipt = {_storeNameTextField.text, _receipt2NumberTextField.text, _receipt8NumberTextField.text , _yearTextField.text, _monthTextField.text, _dayTextField.text, _totalExpenseTextField.text, products};
        NSValue *value = [NSValue valueWithBytes:&receipt objCType:@encode(struct Receipt)];
        [receipts addObject:value];
        NSLog(@"%@",receipts[0]);
        [self.navigationController popViewControllerAnimated:YES];
    }
};

- (void)addProduct:(struct Product *)product{
    struct Product product_back;
    product_back.name = product->name;
    product_back.count = product->count;
    product_back.amount = product->amount;
    product_back.discount = product->discount;
    product_back.productID = product->productID;
    NSValue *value = [NSValue valueWithBytes:&product_back objCType:@encode(struct Product)];
    [products addObject:value];
    [_tableView reloadData];

}

- (void)editProduct:(struct Product *)product and:(nonnull NSIndexPath *)indexPath{
    struct Product product_back;
    product_back.name = product->name;
    product_back.count = product->count;
    product_back.amount = product->amount;
    product_back.discount = product->discount;
    product_back.productID = product->productID;
    NSValue *value = [NSValue valueWithBytes:&product_back objCType:@encode(struct Product)];
    products[indexPath.row] = value;
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"addProduct"]){
        AddProductViewController *addProductViewController = segue.destinationViewController;
        addProductViewController.delegate = self;
    }
    if([segue.identifier isEqual:@"editProduct"]){
        EditProductViewController *editProductViewController = segue.destinationViewController;
        editProductViewController.delegate = self;
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        NSValue *value = [products objectAtIndex:indexPath.row];
        struct Product product;
        [value getValue:&product];
        editProductViewController.product = product;
        editProductViewController.indexPath = indexPath;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return products.count;
}

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

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [products removeObjectAtIndex:indexPath.row];
        [self->_tableView reloadData];
        completionHandler(YES);
    }];
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    deleteAction.backgroundColor = UIColor.systemRedColor;
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}

@end


