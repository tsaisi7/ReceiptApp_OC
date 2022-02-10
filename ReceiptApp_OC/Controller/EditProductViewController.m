//
//  EditProductViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import "EditProductViewController.h"

@interface EditProductViewController ()

@end

@implementation EditProductViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _nameTextField.text = _product.name;
    _countTextField.text = _product.count;
    _amountTextField.text = _product.amount;
    _discountTextField.text = _product.discount;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (IBAction)editProduct:(id)sender{
    if (![_nameTextField.text isEqual:@""] && ![_countTextField.text isEqual:@""] && ![_amountTextField.text isEqual:@""] && ![_discountTextField.text isEqual:@""] && ![_nameTextField.text isEqual:nil] && ![_countTextField.text isEqual:nil] && ![_amountTextField.text isEqual:nil] && ![_discountTextField.text isEqual:nil]){
        _product.name = _nameTextField.text;
        _product.count = _countTextField.text;
        _product.amount = _amountTextField.text;
        _product.discount = _discountTextField.text;
        _product.productID = @"";
        [self.delegate editProduct:&_product and:_indexPath];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 修改商品
@end
