//  EditProductViewController.m
//  ReceiptAppself.OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import "EditProductViewController.h"

@interface EditProductViewController ()

@end

@implementation EditProductViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.text = self.product.name;
    self.countTextField.text = self.product.count;
    self.amountTextField.text = self.product.amount;
    self.discountTextField.text = self.product.discount;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (IBAction)editProduct:(id)sender{
    if (![self.nameTextField.text isEqual:@""] && ![self.countTextField.text isEqual:@""] && ![self.amountTextField.text isEqual:@""] && ![self.discountTextField.text isEqual:@""] && self.nameTextField.text && self.countTextField.text && self.amountTextField.text && self.discountTextField.text){
        self.product.name = self.nameTextField.text;
        self.product.count = self.countTextField.text;
        self.product.amount = self.amountTextField.text;
        self.product.discount = self.discountTextField.text;
        [self.delegate editProduct:self.product and:self.indexPath];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 修改商品
@end
