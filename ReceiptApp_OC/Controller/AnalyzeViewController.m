//
//  AnalyzeViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/14.
//

#import "AnalyzeViewController.h"
@import Firebase;
@interface AnalyzeViewController ()

@end

@implementation AnalyzeViewController

FIRUser *user_showAnlyze;
FIRDocumentReference *ref_showAnlyze;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.now = [NSDate date];
    self.year = [[NSCalendar currentCalendar]component:NSCalendarUnitYear fromDate:self.now];
    
    user_showAnlyze = [FIRAuth auth].currentUser;
    ref_showAnlyze = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user_showAnlyze.uid];
}

- (IBAction)nextMonth:(id)sender{
    if (self.month != 12){
        self.month = self.month + 1;
    }else{
        self.year = self.year + 1;
        self.month = 1;

    }
}

- (IBAction)lastMonth:(id)sender{
    if (self.month != 1){
        self.month = self.month - 1;

    }else{
        self.year = self.year - 1;
        self.month =  12;
    }
}

- (void)getDataWithYear: (NSInteger)year: getDataWithMonth: (NSInteger) month{
    NSString *yearStr = [[NSString alloc]initWithFormat:@"%ld",year-1911];
    NSString *monthStr;
    monthStr = month < 10 ? [[NSString alloc]initWithFormat:@"0%ld",month] : [[NSString alloc]initWithFormat:@"%ld",month];
    [[[[ref_showAnlyze collectionWithPath:@"Receipts"] queryWhereField:@"year" isEqualTo:yearStr] queryWhereField:@"month" isEqualTo:monthStr] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
            self.totalExpense = 0;
            
            for (FIRDocumentSnapshot *document in snapshot.documents){
                NSLog(@"-=-=-=-=%@", document.documentID);
                NSString *storeName = document.data[@"storeName"];
                storeName = [storeName isEqual:@""] ? @"商店名稱" : storeName;
                NSString *totalExpense = document.data[@"totalExpense"];
                totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
                
                if (![totalExpense isEqual:@"尚未輸入金額"]){
                    NSLog(@"1receipt totalExp:  %ld",self.totalExpense);
                    NSLog(@"2receipt totalExpense:  %lu",(unsigned long)[totalExpense intValue]);
                    self.totalExpense = self.totalExpense + [totalExpense intValue];
                    NSLog(@"3receipt totalExp:  %lu",(unsigned long)self.totalExpense);
                }
            }
            
        }
    }];
}

@end
