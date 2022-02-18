//
//  AnalyzeData.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnalyzeData : NSObject

-(void) initialAllAnalyzeData;
-(void) setAnalyzeDataWithMonth:(NSInteger) month WithExpense:(NSInteger) expense;
-(NSArray*) backAnalyzeDataArray;

@end

NS_ASSUME_NONNULL_END
