//
//  ScannerViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import "ScannerViewController.h"
#import "AddReceiptViewController.h"
@import AVFoundation;
@import Firebase;

@interface ScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ScannerViewController

AVCaptureSession *captureSession;
AVCaptureVideoPreviewLayer *previewLayer;
FIRUser *user2;
FIRDocumentReference *ref2;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user2 = [FIRAuth auth].currentUser;
    ref2 = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user2.uid];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setScanner];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![captureSession isRunning]){
        [captureSession startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([captureSession isRunning]){
        [captureSession stopRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if([captureSession isRunning]){
        [captureSession stopRunning];
    }
}

- (void)setScanner{
    captureSession = [AVCaptureSession new];
    AVCaptureDevice *captureDeivce = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!captureDeivce) {
        return;
    }
    AVCaptureDeviceInput *deviceInput;
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDeivce error:nil];
    if ([captureSession canAddInput:deviceInput]){
        [captureSession addInput:deviceInput];
    }else{
        return;
    }
    AVCaptureMetadataOutput *metaDataOutput = [AVCaptureMetadataOutput new];
    if ([captureSession canAddOutput:metaDataOutput]){
        [captureSession addOutput:metaDataOutput];
        [metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        metaDataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code];
    }else{
        return;
    }
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = _scannerView.layer.frame;
    [self.view.layer addSublayer:previewLayer];
    [captureSession startRunning];
}

- (void)alertTitle:(NSString*)title alerMessgae:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    AVMetadataObject *metadataObject = [metadataObjects firstObject];
    AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject*) metadataObject;
    if (!readableObject){
        return;
        
    }
    NSString *stringValue = readableObject.stringValue;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSLog(@"%@",stringValue);
    NSString *regex = @"[A-Z][A-Z][0-9]{19}[A-F0-9]{16}";
    NSRange range = [stringValue rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        [self alertTitle:@"抱歉" alerMessgae:@"無法識別"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"掃描成功" message:[[NSString alloc] initWithFormat:@"發票號碼：%@-%@",[stringValue substringWithRange:NSMakeRange(0, 2)],[stringValue substringWithRange:NSMakeRange(2, 8)]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"直接儲存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *receiptID = [[NSString alloc] initWithFormat: @"%@-%@",[stringValue substringWithRange:NSMakeRange(0, 2)],[stringValue substringWithRange:NSMakeRange(2, 8)]];

        NSDictionary *receiptData = @{
          @"storeName": @"",
          @"receipt2Number": [stringValue substringWithRange:NSMakeRange(0, 2)],
          @"receipt8Number": [stringValue substringWithRange:NSMakeRange(2, 8)],
          @"year": [stringValue substringWithRange:NSMakeRange(10, 3)],
          @"month": [stringValue substringWithRange:NSMakeRange(13, 2)],
          @"day": [stringValue substringWithRange:NSMakeRange(15, 2)],
        };

        [[[ref2 collectionWithPath:@"Receipts"] documentWithPath:receiptID] setData: receiptData completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error writing document: %@", error);
                return;
            } else {
                NSLog(@"Receipt successfully uploaded");
                [self alertTitle:@"提醒" alerMessgae:@"發票上傳成功"];
            }
        }];
    }];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"編輯發票" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AddReceiptViewController *addReceiptViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addReceiptViewController"];
        addReceiptViewController.receipt2Number = [stringValue substringWithRange:NSMakeRange(0, 2)];
        addReceiptViewController.receipt8Number = [stringValue substringWithRange:NSMakeRange(2, 8)];
        NSScanner *scanner = [NSScanner scannerWithString:[stringValue substringWithRange:NSMakeRange(29, 8)]];
        unsigned int outValue;
        [scanner scanHexInt:&outValue];
        NSString *totalExpString = [[NSString alloc] initWithFormat:@"%d",outValue];
        addReceiptViewController.totalExpense = totalExpString;
        addReceiptViewController.year = [stringValue substringWithRange:NSMakeRange(10, 3)];
        addReceiptViewController.month = [stringValue substringWithRange:NSMakeRange(13, 2)];
        addReceiptViewController.day = [stringValue substringWithRange:NSMakeRange(15, 2)];
        [self.navigationController pushViewController:addReceiptViewController animated:YES];
    }];
    [alert addAction:saveAction];
    [alert addAction:editAction];
    [self presentViewController:alert animated:YES completion:nil];
}
  
@end
