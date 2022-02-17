//
//  AnalyzeViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/14.
//

#import "AnalyzeViewController.h"
#import "AAChartKit.h"
#import "AnalyzeData.h"

@import Firebase;

@interface AnalyzeViewController ()

@end

@implementation AnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.group =dispatch_group_create();
    self.queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    self.data = [[AnalyzeData alloc] init];
    self.user = [FIRAuth auth].currentUser;
    self.ref = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:self.user.uid];
    
    self.now = [NSDate date];
    self.year = [[NSCalendar currentCalendar]component:NSCalendarUnitYear fromDate:self.now];
    self.dates = [self.data clearAnalyzeDataArray];
    [self getDateWithYear:self.year];
    
    
    CGFloat chartViewWidth = self.chartView.frame.size.width;
    CGFloat chartViewHeight = self.chartView.frame.size.height;
    self.aaChartView = [[AAChartView alloc]init];
    self.aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    [self.chartView addSubview:self.aaChartView];
    
    self.aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypePie)
    .tooltipValueSuffixSet(@"NTD")
    .colorsThemeSet(@[@"#F4E500",@"#FDC60B",@"#F18E1C",@"#EA621F",@"#E32322",@"#E32322",@"#6D398B",@"#444E99",@"#2A71B0",@"#0696BB",@"#008E5B",@"#8CBB26"])
    .seriesSet(@[AASeriesElement.new
                     .nameSet(@"消費金額")
                     .innerSizeSet(@"50%")
                     .dataSet(self.dates)]);
    dispatch_group_notify(self.group,dispatch_get_main_queue(), ^{
        [self.aaChartView aa_drawChartWithChartModel:self.aaChartModel];
        NSLog(@"DONE");
    });

}

- (IBAction)nextMonth:(id)sender{
    self.year = self.year + 1;
    self.yearLabel.text = [[NSString alloc]initWithFormat:@"%ld",self.year-1911];
    self.dates = [self.data clearAnalyzeDataArray];
    [self getDateWithYear:self.year];
    dispatch_group_notify(self.group,dispatch_get_main_queue(), ^{
        self.aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypePie)
        .tooltipValueSuffixSet(@"NTD")
        .colorsThemeSet(@[@"#F4E500",@"#FDC60B",@"#F18E1C",@"#EA621F",@"#E32322",@"#E32322",@"#6D398B",@"#444E99",@"#2A71B0",@"#0696BB",@"#008E5B",@"#8CBB26"])
        .seriesSet(@[AASeriesElement.new
                        .nameSet(@"消費金額")
                        .innerSizeSet(@"50%")
                        .dataSet(self.dates)]);
        [self.aaChartView aa_refreshChartWithChartModel:self.aaChartModel];
        NSLog(@"DONE");
    });
}

- (IBAction)lastMonth:(id)sender{
    self.year = self.year - 1;
    self.yearLabel.text = [[NSString alloc]initWithFormat:@"%ld",self.year-1911];
    self.dates = [self.data clearAnalyzeDataArray];

    [self getDateWithYear:self.year];
    dispatch_group_notify(self.group,dispatch_get_main_queue(), ^{
        self.aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypePie)
        .tooltipValueSuffixSet(@"NTD")
        .colorsThemeSet(@[@"#F4E500",@"#FDC60B",@"#F18E1C",@"#EA621F",@"#E32322",@"#E32322",@"#6D398B",@"#444E99",@"#2A71B0",@"#0696BB",@"#008E5B",@"#8CBB26"])
        .seriesSet(@[AASeriesElement.new
                        .nameSet(@"消費金額")
                        .innerSizeSet(@"50%")
                        .dataSet(self.dates)]);

        [self.aaChartView aa_refreshChartWithChartModel:self.aaChartModel];
        NSLog(@"DONE");
    });
}

- (void)getDateWithYear:(NSInteger)year{
    for (int i = 1; i < 13; i++){
        NSString *yearStr = [[NSString alloc]initWithFormat:@"%ld",year-1911];
        NSString *monthStr;
        monthStr = i < 10 ? [[NSString alloc]initWithFormat:@"0%d",i] : [[NSString alloc]initWithFormat:@"%d",i];
        dispatch_group_enter(self.group);
        [[[[self.ref collectionWithPath:@"Receipts"] queryWhereField:@"year" isEqualTo:yearStr] queryWhereField:@"month" isEqualTo:monthStr] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (error != nil){
                NSLog(@"ERROR");
                dispatch_group_leave(self.group);
                return;
            }
            if (snapshot != nil){
                NSInteger totalExp = 0;
                for (FIRDocumentSnapshot *document in snapshot.documents){
                    NSString *totalExpense = document.data[@"totalExpense"];
                    totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
                    if (![totalExpense isEqual:@"尚未輸入金額"]){
                        totalExp = totalExp + [totalExpense intValue];
                    }
                    [self.data setMonth:i setExpense:totalExp];
                    NSArray *array = [self.data getAnalyzeData];
                    [self.dates setObject:array atIndexedSubscript:i-1];
                }
                NSLog(@"TEST");
                dispatch_group_leave(self.group);
            }
        }];
    }
}

@end
