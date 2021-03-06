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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [FIRAuth auth].currentUser;
    self.ref = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:self.user.uid];
    self.IDs = [NSMutableArray array];
    [self getReceiptID];
}

- (void)getReceiptID{
    [[self.ref collectionWithPath:@"Receipts"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot){
            for (FIRDocumentSnapshot *document in snapshot.documents){
                [self.IDs addObject:document.documentID];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setScanner];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![self.captureSession isRunning]){
        [self.captureSession startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([self.captureSession isRunning]){
        [self.captureSession stopRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if([self.captureSession isRunning]){
        [self.captureSession stopRunning];
    }
}

- (void)setScanner{
    self.captureSession = [AVCaptureSession new];
    AVCaptureDevice *captureDeivce = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!captureDeivce) {
        return;
    }
    AVCaptureDeviceInput *deviceInput;
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDeivce error:nil];
    if ([self.captureSession canAddInput:deviceInput]){
        [self.captureSession addInput:deviceInput];
    }else{
        return;
    }
    AVCaptureMetadataOutput *metaDataOutput = [AVCaptureMetadataOutput new];
    if ([self.captureSession canAddOutput:metaDataOutput]){
        [self.captureSession addOutput:metaDataOutput];
        [metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        metaDataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code];
    }else{
        return;
    }
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = _scannerView.layer.frame;
    [self.view.layer addSublayer:self.previewLayer];
    [self.captureSession startRunning];
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
    NSLog(@"input: %@",stringValue);
    NSString *regex = @"[A-Z][A-Z][0-9]{19}[a-fA-F0-9]{16}";
    NSRange range = [stringValue rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        [self alertTitle:@"??????" alerMessgae:@"????????????"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"????????????" message:[[NSString alloc] initWithFormat:@"???????????????%@-%@",[stringValue substringWithRange:NSMakeRange(0, 2)],[stringValue substringWithRange:NSMakeRange(2, 8)]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"????????????" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *receiptID = [[NSString alloc] initWithFormat: @"%@-%@",[stringValue substringWithRange:NSMakeRange(0, 2)],[stringValue substringWithRange:NSMakeRange(2, 8)]];
        
        for (NSString *ID in self.IDs){
            if ([ID isEqual:receiptID]){
                [self alertTitle:@"??????" alerMessgae:@"??????????????????"];
                return;
            }
        }
        
        NSScanner *scanner = [NSScanner scannerWithString:[stringValue substringWithRange:NSMakeRange(29, 8)]];
        unsigned int outValue;
        [scanner scanHexInt:&outValue];
        NSString *totalExpString = [[NSString alloc] initWithFormat:@"%d",outValue];
        
        NSDictionary *receiptData = @{
          @"storeName": @"",
          @"receipt2Number": [stringValue substringWithRange:NSMakeRange(0, 2)],
          @"receipt8Number": [stringValue substringWithRange:NSMakeRange(2, 8)],
          @"year": [stringValue substringWithRange:NSMakeRange(10, 3)],
          @"month": [stringValue substringWithRange:NSMakeRange(13, 2)],
          @"day": [stringValue substringWithRange:NSMakeRange(15, 2)],
          @"totalExpense": totalExpString
        };

        [[[self.ref collectionWithPath:@"Receipts"] documentWithPath:receiptID] setData: receiptData completion:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error writing document: %@", error);
                return;
            } else {
                NSLog(@"Receipt successfully uploaded");
                [self alertTitle:@"??????" alerMessgae:@"??????????????????"];
            }
        }];
    }];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"????????????" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
