//
//  ScannerViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScannerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *scannerView;

@property NSMutableArray* IDs;

@end

NS_ASSUME_NONNULL_END
