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
    self.dates = [NSMutableArray arrayWithObjects:@[@"01月",@0],@[@"02月",@0],@[@"03月",@0],@[@"04月",@0],@[@"05月",@0],@[@"06月",@0],@[@"07月",@0],@[@"08月",@0],@[@"09月",@0],@[@"10月",@0],@[@"11月",@0],@[@"12月",@0], nil];
    user_showAnlyze = [FIRAuth auth].currentUser;
    ref_showAnlyze = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user_showAnlyze.uid];
    
    for (int i = 1; i < 13; i++){
        [self getDateWithYear:2021 month:i];
    }
}

- (IBAction)nextMonth:(id)sender{
    self.year = self.year + 1;
    self.yearLabel.text = [[NSString alloc]initWithFormat:@"%ld",self.year-1911];
    for (int i = 1; i < 13; i++){
        [self getDateWithYear:self.year month:i];
    }
}

- (IBAction)lastMonth:(id)sender{
    self.year = self.year - 1;
    self.yearLabel.text = [[NSString alloc]initWithFormat:@"%ld",self.year-1911];
    for (int i = 1; i < 13; i++){
        [self getDateWithYear:self.year month:i];
    }
}

- (void)getDateWithYear:(NSInteger)year month:(NSInteger) month{
    NSString *yearStr = [[NSString alloc]initWithFormat:@"%ld",year-1911];
    NSString *monthStr;
    monthStr = month < 10 ? [[NSString alloc]initWithFormat:@"0%ld",month] : [[NSString alloc]initWithFormat:@"%ld",month];
    [[[[ref_showAnlyze collectionWithPath:@"Receipts"] queryWhereField:@"year" isEqualTo:yearStr] queryWhereField:@"month" isEqualTo:monthStr] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"ERROR");
            return;
        }
        if (snapshot != nil){
            NSInteger totalExp = 0;
            for (FIRDocumentSnapshot *document in snapshot.documents){
                NSLog(@"TEST");

                NSLog(@"-=-=-=-=%@", document.documentID);
                NSString *totalExpense = document.data[@"totalExpense"];
                totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
                
                if (![totalExpense isEqual:@"尚未輸入金額"]){
                    NSLog(@"1receipt totalExp:  %ld",totalExp);
                    NSLog(@"2receipt totalExpense:  %lu",(unsigned long)[totalExpense intValue]);
                    totalExp = totalExp + [totalExpense intValue];
                    NSLog(@"3receipt totalExp:  %lu",(unsigned long)totalExp);
                }
                NSLog(@"%ld",(long)month);
                NSArray *array = @[[[NSString alloc]initWithFormat:@"%ld月",(long)month],[[NSString alloc]initWithFormat:@"%ld",(long)totalExp]];
                [self.dates setObject:array atIndexedSubscript:month-1];
            }
        }
    }];
}

@end
