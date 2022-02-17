//
//  WinningReceiptViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WinningReceiptViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField* yearTextField;
@property (weak, nonatomic) IBOutlet UIPickerView* monthPickerView;
@property (weak, nonatomic) IBOutlet UITextField* winningNumberTextField;
@property NSArray *monthArray;
@property NSInteger receipt_month;
@end

NS_ASSUME_NONNULL_END
