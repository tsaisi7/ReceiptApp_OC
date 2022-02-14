//
//  YearTextField.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/14.
//

#import "YearTextField.h"

@implementation YearTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentText = textField.text;
    NSString *prospectiveText = [currentText stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *disallowedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSLog(@"TEST %d",prospectiveText.length <= 3);
    return prospectiveText.length <= 3 && [string rangeOfCharacterFromSet:disallowedCharacterSet].location == NSNotFound;
}

@end
