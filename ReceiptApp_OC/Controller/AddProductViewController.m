//
//  AddProductViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/8.
//

#import "AddProductViewController.h"
#import "Product.h"

@interface AddProductViewController ()

@end

@implementation AddProductViewController

struct Product product;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (IBAction)addProduct:(id)sender{
    if (![_nameTextField.text isEqual:@""] && ![_countTextField.text isEqual:@""] && ![_amountTextField.text isEqual:@""] && ![_discountTextField.text isEqual:@""] && ![_nameTextField.text isEqual:nil] && ![_countTextField.text isEqual:nil] && ![_amountTextField.text isEqual:nil] && ![_discountTextField.text isEqual:nil]){
        NSLog(@"%@", self.nameTextField.text);
        NSLog(@"%@", _nameTextField.text);
        product.name = self.nameTextField.text;
        product.count = _countTextField.text;
        product.amount = _amountTextField.text;
        product.discount = _discountTextField.text;
        product.productID = @"";
        [self.delegate addProduct:&product];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 新增商品

@end
