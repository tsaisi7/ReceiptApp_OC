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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.product = [[Product alloc]init];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (IBAction)addProduct:(id)sender{
    if (![self.nameTextField.text isEqual:@""] && ![self.countTextField.text isEqual:@""] && ![self.amountTextField.text isEqual:@""] && ![self.discountTextField.text isEqual:@""] && self.nameTextField.text && self.countTextField.text && self.amountTextField.text && self.discountTextField.text){
        self.product.name = self.nameTextField.text;
        self.product.count = self.countTextField.text;
        self.product.amount= self.amountTextField.text;
        self.product.discount = self.discountTextField.text;
        [self.delegate addProduct: self.product];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 新增商品

@end
