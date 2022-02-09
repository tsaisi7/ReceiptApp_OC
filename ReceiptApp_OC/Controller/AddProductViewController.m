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
    // Do any additional setup after loading the view.
}

- (IBAction)addProduct:(id)sender{
    if (![_nameTextField.text isEqual:@""] && ![_countTextField.text isEqual:@""] && ![_amountTextField.text isEqual:@""] && ![_discountTextField.text isEqual:@""] && ![_nameTextField.text isEqual:nil] && ![_countTextField.text isEqual:nil] && ![_amountTextField.text isEqual:nil] && ![_discountTextField.text isEqual:nil]){
        product.name = _nameTextField.text;
        product.count = _countTextField.text;
        product.amount = _amountTextField.text;
        product.discount = _discountTextField.text;
        product.productID = @"";
        [self.delegate addProduct:&product];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
