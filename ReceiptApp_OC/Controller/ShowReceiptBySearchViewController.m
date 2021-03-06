//
//  ShowReceiptBySearchViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/13.
//

#import "ShowReceiptBySearchViewController.h"
#import "ShowReceiptDetailViewController.h"
#import "ReceiptTableViewCell.h"
#import "Receipt.h"
#import "Product.h"
@import Firebase;

@interface ShowReceiptBySearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@end

@implementation ShowReceiptBySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [FIRAuth auth].currentUser;
    self.ref = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:self.user.uid];
    
    [self readData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchBar.text = @"";
    self.receipts = [NSMutableArray array];
    self.searchReceipts = [[NSArray alloc]init];
    self.products = [[NSMutableArray alloc]init];
    [self.tableView reloadData];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)readData{
    [[self.ref collectionWithPath:@"Receipts"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot){
            for (FIRDocumentSnapshot *document in snapshot.documents){
                [[[[self.ref collectionWithPath:@"Receipts"]documentWithPath:document.documentID]collectionWithPath:@"products"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
                    if (error){
                        NSLog(@"ERROR");
                        return;
                    }
                    if (snapshot){
                        NSMutableArray *products = [[NSMutableArray alloc]init];
                        for (FIRDocumentSnapshot *document in snapshot.documents){
                            Product *product = [[Product alloc]init];
                            product.name = document.data[@"name"];
                            product.count = document.data[@"count"];
                            product.amount = document.data[@"amount"];
                            product.discount = document.data[@"discount"];
                            product.productID = document.documentID;
                            [products addObject:product];
                        }
                        
                        NSString *storeName = document.data[@"storeName"];
                        storeName = [storeName isEqual:@""] ? @"????????????" : storeName;
                        NSString *totalExpense = document.data[@"totalExpense"];
                        totalExpense = [totalExpense isEqual:@""] ? @"??????????????????" : totalExpense;
                        Receipt *receipt = [[Receipt alloc] init];
                        receipt.storeName = storeName;
                        receipt.receipt2Number = document.data[@"receipt2Number"];
                        receipt.receipt8Number = document.data[@"receipt8Number"];
                        receipt.year = document.data[@"year"];
                        receipt.month = document.data[@"month"];
                        receipt.day = document.data[@"day"];
                        receipt.totalExpense = totalExpense;
                        receipt.receiptID = document.documentID;
                        receipt.products = products;

                        [self.receipts addObject: receipt];
                    }
                }];
                
            }
        }
    }];
}
// ??????????????????

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual: @"showDetailBySearch"]){
        ShowReceiptDetailViewController *showReceiptDetailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Receipt *receipt = self.searchReceipts[indexPath.row];
        showReceiptDetailViewController.receiptID = receipt.receiptID;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchReceipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ReceiptTableViewCell *cell = (ReceiptTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"receiptBySearchCell" forIndexPath: indexPath];
    Receipt *receipt = [self.searchReceipts objectAtIndex:indexPath.row];

    cell.storeNameLabel.text = receipt.storeName;
    cell.receipt2NumberLabel.text = receipt.receipt2Number;
    cell.receipt8NumberLabel.text = receipt.receipt8Number;
    cell.totalExpenseLabel.text = receipt.totalExpense;
    cell.dateLabel.text = [[NSString alloc]initWithFormat:@"%@/%@",receipt.month,receipt.day];
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Receipt *receipt = [self.searchReceipts objectAtIndex:indexPath.row];
        [[[self.ref collectionWithPath:@"Receipts"]documentWithPath:receipt.receiptID]deleteDocumentWithCompletion:^(NSError * _Nullable error) {
            if (error){
                return;
            }
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"??????" message:@"??????????????????" preferredStyle:UIAlertControllerStyleAlert];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Receipt* evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        NSLog(@"0====%@",evaluatedObject.storeName);
        NSLog(@"1====%@",evaluatedObject.products);
        for (Product* product in evaluatedObject.products){
            NSLog(@"2====%@",product.name);
            if ([evaluatedObject.storeName localizedCaseInsensitiveContainsString:searchText] || [product.name localizedCaseInsensitiveContainsString:searchText]){
                return YES;
            }
        }
        return [evaluatedObject.storeName localizedCaseInsensitiveContainsString:searchText];
    }];
    self.searchReceipts = [self.receipts filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}
// ????????????searchText ??????searchReceipts???

@end
