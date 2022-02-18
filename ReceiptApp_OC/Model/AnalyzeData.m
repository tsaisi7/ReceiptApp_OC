//
//  AnalyzeData.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/16.
//

#import "AnalyzeData.h"

@interface AnalyzeData()

@property (nonatomic) NSMutableDictionary *dataDictionary;

@end

@implementation AnalyzeData

-(void) initialAllAnalyzeData{
    self.dataDictionary = [[NSMutableDictionary alloc]init];
    for (int i = 1; i<13 ; i++){
        [self.dataDictionary setObject:[NSNumber numberWithInteger: 0] forKey:[NSNumber numberWithInteger: i]];
    }
}

-(void) setAnalyzeDataWithMonth:(NSNumber*)month WithExpense:(NSNumber*)expense{
    [self.dataDictionary setObject: expense forKey: month];
}

-(NSArray*) backAnalyzeDataArray{
    NSArray *data = [[NSArray alloc]init];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (NSInteger i=1; i<13 ; i++){
        data = @[[[NSString alloc]initWithFormat:@"%ld月",(long)i], self.dataDictionary[@(i)]];
        [dataArray addObject:data];
    }
    return dataArray;
}

/* dataArray dictionary (Done)
{
   NSNumber:NSNumber

}*/
// private var (Done)

@end
