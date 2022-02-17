//
//  AnalyzeData.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnalyzeData : NSObject{
    NSString *month;
    NSNumber *expense;
}

-(void) setMonth: (NSInteger) m setExpense: (NSInteger) e;
-(NSArray*) getAnalyzeData;
-(NSMutableArray*) clearAnalyzeDataArray;

@end

NS_ASSUME_NONNULL_END
