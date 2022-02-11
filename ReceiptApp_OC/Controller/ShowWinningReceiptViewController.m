//
//  ShowWinningReceiptViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/11.
//

#import "ShowWinningReceiptViewController.h"
#import "Receipt.h"
#import "Product.h"
@import Firebase;

@interface ShowWinningReceiptViewController ()

@end

@implementation ShowWinningReceiptViewController

NSString* monthStr;
NSString* month2Str;
FIRUser* user7;
FIRDocumentReference* ref7;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user7 = [FIRAuth auth].currentUser;
    ref7 = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user7.uid];
    monthStr = self.month <10 ? [[NSString alloc]initWithFormat:@"0%ld",(long)self.month] :[[NSString alloc]initWithFormat:@"%ld",(long)self.month];
    month2Str = self.month2 <10 ? [[NSString alloc]initWithFormat:@"0%ld",(long)self.month2] :[[NSString alloc]initWithFormat:@"%ld",(long)self.month2];
    self.yearLabel.text = self.year;
    self.monthLabel.text = monthStr;
    self.month2Label.text = month2Str;
    self.receipts = [[NSMutableArray alloc]init];
    [self readData];
}

- (void)readData{
    [[[[ref7 collectionWithPath:@"Receipts"]queryWhereField:@"year" isEqualTo:self.year]queryWhereField:@"month" in:@[monthStr,month2Str]]getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
            for (FIRDocumentSnapshot *document in snapshot.documents){
                NSLog(@"-=-=-=-=%@", document.documentID);
                NSString *storeName = document.data[@"storeName"];
                storeName = [storeName isEqual:@""] ? @"商店名稱" : storeName;
                NSString *totalExpense = document.data[@"totalExpense"];
                totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
                Receipt *receipt = [[Receipt alloc] init];
                receipt.storeName = storeName;
                receipt.receipt2Number = document.data[@"receipt2Number"];
                receipt.receipt8Number = document.data[@"receipt8Number"];
                receipt.year = document.data[@"year"];
                receipt.month = document.data[@"month"];
                receipt.day = document.data[@"day"];
                receipt.totalExpense = totalExpense;
                receipt.receiptID = document.documentID;
                [self.receipts addObject: receipt];
            }
            [self check];
        }
    }];
}

- (void)check{
//    const char *c = [self.winningNumber UTF8String];
//    for(Receipt *receipt in self.receipts){
//        const char *r = [receipt.receipt8Number UTF8String];
//        if (!(c[7] == r[7] && c[6] == r[6] && c[5] == r[5]) ){
//            return;
//        }
//        if (!(c[4] == r[4]) ){
//            
//        }
//    }
}
 
@end
