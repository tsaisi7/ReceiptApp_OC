//
//  MonthTextField.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/14.
//

#import "MonthTextField.h"

@implementation MonthTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentText = textField.text;
    NSString *prospectiveText = [currentText stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *disallowedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSLog(@"TEST %d",prospectiveText.length <= 2);
    return prospectiveText.length <= 2 && [string rangeOfCharacterFromSet:disallowedCharacterSet].location == NSNotFound;
}

@end
