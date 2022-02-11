//
//  WinningReceiptViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import "WinningReceiptViewController.h"
#import "ShowWinningReceiptViewController.h"

@interface WinningReceiptViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation WinningReceiptViewController

NSArray *monthArray;
NSInteger receipt_month = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    monthArray = [NSArray arrayWithObjects:@"1月＆2月",@"3月＆4月",@"5月＆6月",@"7月＆8月",@"9月＆10月",@"11月＆12月", nil];
    self.monthPickerView.delegate = self;
    self.monthPickerView.dataSource = self;
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
// 收起鍵盤

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.winningNumberTextField.text = @"";
}

-(IBAction)searchRecceipt:(id)sender{
    if (![self.yearTextField.text isEqual:@""] && ![self.winningNumberTextField.text isEqual:@""]){
        ShowWinningReceiptViewController *showWinningReceiptViewCtroller = [self.storyboard instantiateViewControllerWithIdentifier:@"showWinningReceiptViewCtroller"];
        showWinningReceiptViewCtroller.year = self.yearTextField.text;
        showWinningReceiptViewCtroller.month = receipt_month;
        showWinningReceiptViewCtroller.month2 = receipt_month+1;
        showWinningReceiptViewCtroller.winningNumber = self.winningNumberTextField.text;
        NSLog(@"TEST");
        [self.navigationController pushViewController:showWinningReceiptViewCtroller animated:YES];
    }else{
        NSLog(@"ERROR");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"請輸入完整資料" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];

        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return monthArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return monthArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    receipt_month = row *2 +1;
    NSLog(@"%ld",(long)receipt_month);
}

@end
