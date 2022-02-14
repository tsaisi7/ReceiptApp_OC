//
//  AnalyzeViewController.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/14.
//

#import "AnalyzeViewController.h"
#import "AAChartKit.h"
@import Firebase;
@interface AnalyzeViewController ()

@end

@implementation AnalyzeViewController

FIRUser *user_showAnlyze;
FIRDocumentReference *ref_showAnlyze;
AAChartView *aaChartView;
AAChartModel *aaChartModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.now = [NSDate date];
    self.year = [[NSCalendar currentCalendar]component:NSCalendarUnitYear fromDate:self.now];
    
    user_showAnlyze = [FIRAuth auth].currentUser;
    ref_showAnlyze = [[[FIRFirestore firestore] collectionWithPath:@"Users"] documentWithPath:user_showAnlyze.uid];
    
    self.dates = [NSMutableArray arrayWithObjects:@[@"01月",@0],@[@"02月",@0],@[@"03月",@0],@[@"04月",@0],@[@"05月",@0],@[@"06月",@0],@[@"07月",@0],@[@"08月",@0],@[@"09月",@0],@[@"10月",@0],@[@"11月",@0],@[@"12月",@0], nil];
    for (int i = 1; i < 13; i++){
        [self getDateWithYear:self.year month:i];
    }
    
    CGFloat chartViewWidth = self.chartView.frame.size.width;
    CGFloat chartViewHeight = self.chartView.frame.size.height;
    aaChartView = [[AAChartView alloc]init];
    aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    [self.chartView addSubview:aaChartView];
    
    aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypePie)
    .tooltipValueSuffixSet(@"NTD")
    .colorsThemeSet(@[@"#F4E500",@"#FDC60B",@"#F18E1C",@"#EA621F",@"#E32322",@"#E32322",@"#6D398B",@"#444E99",@"#2A71B0",@"#0696BB",@"#008E5B",@"#8CBB26"])
    .seriesSet(@[AASeriesElement.new
                     .nameSet(@"消費金額")
                     .innerSizeSet(@"50%")
                     .dataSet(self.dates)]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [aaChartView aa_drawChartWithChartModel:aaChartModel];
    });

}

- (IBAction)nextMonth:(id)sender{
    self.year = self.year + 1;
    self.yearLabel.text = [[NSString alloc]initWithFormat:@"%ld",self.year-1911];
    self.dates = [NSMutableArray arrayWithObjects:@[@"01月",@0],@[@"02月",@0],@[@"03月",@0],@[@"04月",@0],@[@"05月",@0],@[@"06月",@0],@[@"07月",@0],@[@"08月",@0],@[@"09月",@0],@[@"10月",@0],@[@"11月",@0],@[@"12月",@0], nil];
    for (int i = 1; i < 13; i++){
        [self getDateWithYear:self.year month:i];
    }
    
    CGFloat chartViewWidth = self.chartView.frame.size.width;
    CGFloat chartViewHeight = self.chartView.frame.size.height;
    aaChartView = [[AAChartView alloc]init];
    aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    [self.chartView addSubview:aaChartView];
    
    aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypePie)
    .tooltipValueSuffixSet(@"NTD")
    .colorsThemeSet(@[@"#F4E500",@"#FDC60B",@"#F18E1C",@"#EA621F",@"#E32322",@"#E32322",@"#6D398B",@"#444E99",@"#2A71B0",@"#0696BB",@"#008E5B",@"#8CBB26"])
    .seriesSet(@[AASeriesElement.new
                     .nameSet(@"消費金額")
                     .innerSizeSet(@"50%")
                     .dataSet(self.dates)]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [aaChartView aa_drawChartWithChartModel:aaChartModel];
    });
}

- (IBAction)lastMonth:(id)sender{
    self.year = self.year - 1;
    self.yearLabel.text = [[NSString alloc]initWithFormat:@"%ld",self.year-1911];
    self.dates = [NSMutableArray arrayWithObjects:@[@"01月",@0],@[@"02月",@0],@[@"03月",@0],@[@"04月",@0],@[@"05月",@0],@[@"06月",@0],@[@"07月",@0],@[@"08月",@0],@[@"09月",@0],@[@"10月",@0],@[@"11月",@0],@[@"12月",@0], nil];
    for (int i = 1; i < 13; i++){
        [self getDateWithYear:self.year month:i];
    }
    
    CGFloat chartViewWidth = self.chartView.frame.size.width;
    CGFloat chartViewHeight = self.chartView.frame.size.height;
    aaChartView = [[AAChartView alloc]init];
    aaChartView.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight);
    [self.chartView addSubview:aaChartView];
    
    aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypePie)
    .tooltipValueSuffixSet(@"NTD")
    .colorsThemeSet(@[@"#F4E500",@"#FDC60B",@"#F18E1C",@"#EA621F",@"#E32322",@"#E32322",@"#6D398B",@"#444E99",@"#2A71B0",@"#0696BB",@"#008E5B",@"#8CBB26"])
    .seriesSet(@[AASeriesElement.new
                     .nameSet(@"消費金額")
                     .innerSizeSet(@"50%")
                     .dataSet(self.dates)]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [aaChartView aa_drawChartWithChartModel:aaChartModel];
    });
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
                NSString *totalExpense = document.data[@"totalExpense"];
                totalExpense = [totalExpense isEqual:@""] ? @"尚未輸入金額" : totalExpense;
                if (![totalExpense isEqual:@"尚未輸入金額"]){
                    totalExp = totalExp + [totalExpense intValue];
                }
                NSArray *array = @[[[NSString alloc]initWithFormat:@"%ld月",(long)month],[[NSNumber alloc]initWithInteger: totalExp]];
                [self.dates setObject:array atIndexedSubscript:month-1];
            }
        }
    }];
}

@end
