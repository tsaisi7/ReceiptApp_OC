//
//  Receipt.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct Receipt{
    NSString *storeName;
    NSString *receipt2Number;
    NSString *receipt8Number;
    NSString *year;
    NSString *month;
    NSString *day;
    NSString *totalExpense;
    NSMutableArray *products;
};

@interface Receipt : NSObject

@end

NS_ASSUME_NONNULL_END
