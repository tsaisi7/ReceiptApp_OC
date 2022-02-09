//
//  Product.h
//  ReceiptApp_OC
//
//  Created by CAI SI LIOU on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct Product {
    NSString *name;
    NSString *count;
    NSString *amount;
    NSString *discount;
    NSString *productID;
};

@interface Product : NSObject

@end

NS_ASSUME_NONNULL_END
