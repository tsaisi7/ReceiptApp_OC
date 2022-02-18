//
//  AnalyzeViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/14.
//

#import <UIKit/UIKit.h>
#import "AAChartKit.h"
#import "AnalyzeData.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface AnalyzeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel* yearLabel;
@property (weak, nonatomic) IBOutlet UIButton* leftButton;
@property (weak, nonatomic) IBOutlet UIButton* rightButton;
@property (weak, nonatomic) IBOutlet UIView* chartView;
@property NSDate* now;
@property NSInteger year;
@property NSInteger month;
@property NSInteger totalExpense;
@property FIRUser *user;
@property FIRDocumentReference *ref;
@property AAChartView *aaChartView;
@property AAChartModel *aaChartModel;
@property dispatch_group_t group;
@property dispatch_queue_t queue;
@property AnalyzeData *data;

@end

NS_ASSUME_NONNULL_END
