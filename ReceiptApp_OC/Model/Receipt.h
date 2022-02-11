//
//  Receipt.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Receipt : NSObject

@property NSString *receiptID;
@property NSString *storeName;
@property NSString *receipt2Number;
@property NSString *receipt8Number;
@property NSString *year;
@property NSString *month;
@property NSString *day;
@property NSString *totalExpense;
@property NSMutableArray *products;

@end

NS_ASSUME_NONNULL_END
