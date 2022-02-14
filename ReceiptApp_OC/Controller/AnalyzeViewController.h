//
//  AnalyzeViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/14.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AnalyzeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel* yearLabel;
@property (weak, nonatomic) IBOutlet UIButton* leftButton;
@property (weak, nonatomic) IBOutlet UIButton* rightButton;
@property (weak, nonatomic) IBOutlet UIView* chartView;
@property NSMutableArray* dates;
@property NSDate* now;
@property NSInteger year;
@property NSInteger month;
@property NSInteger totalExpense;


@end

NS_ASSUME_NONNULL_END
