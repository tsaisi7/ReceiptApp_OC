//
//  ScannerViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import "ScannerViewController.h"
#import "AddReceiptViewController.h"
@import AVFoundation;

@interface ScannerViewController ()< AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ScannerViewController

AVCaptureSession *captureSession;
AVCaptureVideoPreviewLayer *previewLayer;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setScanner];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([captureSession isRunning] == NO){
        [captureSession startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([captureSession isRunning] == YES){
        [captureSession stopRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if([captureSession isRunning] == YES){
        [captureSession stopRunning];
    }
}

- (void)setScanner{
    captureSession = [AVCaptureSession new];
    AVCaptureDevice *captureDeivce = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (captureDeivce == nil) {
        NSLog(@"----0");
        return;
    }
    AVCaptureDeviceInput *deviceInput;
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDeivce error:nil];
    if ([captureSession canAddInput:deviceInput]){
        [captureSession addInput:deviceInput];
    }else{
        NSLog(@"----1");
        return;
    }
    AVCaptureMetadataOutput *metaDataOutput = [AVCaptureMetadataOutput new];
    if ([captureSession canAddOutput:metaDataOutput]){
        [captureSession addOutput:metaDataOutput];
        [metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        metaDataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code];
    }else{
        NSLog(@"----2");
        return;
    }
    
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = _scannerView.layer.frame;
    [self.view.layer addSublayer:previewLayer];
    [captureSession startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    AVMetadataObject *metadataObject = [metadataObjects firstObject];
    AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject*) metadataObject;
    if (readableObject == nil){
        NSLog(@"----4");
        return;
        
    }
    NSString *stringValue = readableObject.stringValue;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
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
}
  
@end
