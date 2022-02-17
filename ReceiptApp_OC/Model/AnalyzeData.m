//
//  AnalyzeData.m
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/16.
//

#import "AnalyzeData.h"

@implementation AnalyzeData

-(void) setMonth:(NSInteger)m setExpense:(NSInteger)e{
    month = [[NSString alloc]initWithFormat:@"%ld月",(long)m];
    expense = [[NSNumber alloc]initWithInteger: e];
}

-(NSArray*)getAnalyzeData{
    return @[month,expense];
}

-(NSMutableArray*)clearAnalyzeDataArray{
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray removeAllObjects];
    for (int i = 1; i<13 ; i++){
        [self setMonth:i setExpense:0];
        NSArray* data = [NSArray array];
        data = [self getAnalyzeData];
        [dataArray addObject: data];
    }
    return dataArray;
}

@end
