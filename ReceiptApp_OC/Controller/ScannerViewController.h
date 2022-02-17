//
//  ScannerViewController.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface ScannerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *scannerView;

@property NSMutableArray* IDs;
@property FIRUser* user;
@property FIRDocumentReference* ref;
@property AVCaptureSession *captureSession;
@property AVCaptureVideoPreviewLayer *previewLayer;
@end

NS_ASSUME_NONNULL_END
