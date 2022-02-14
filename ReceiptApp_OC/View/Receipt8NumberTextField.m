//
//  Receipt8NumberTextField.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/14.
//

#import "Receipt8NumberTextField.h"

@implementation Receipt8NumberTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *currentText = textField.text;
    NSString *prospectiveText = [currentText stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *disallowedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return prospectiveText.length <= 8 && [string rangeOfCharacterFromSet:disallowedCharacterSet].location == NSNotFound;
}

@end
