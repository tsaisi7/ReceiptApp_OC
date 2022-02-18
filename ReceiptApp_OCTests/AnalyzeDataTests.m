//
//  AnalyzeDataTests.m
//  ReceiptApp_OCTests
//
//  Created by Adam Liu on 2022/2/18.
//

#import <XCTest/XCTest.h>
#import "AnalyzeData.h"

@interface AnalyzeDataTests : XCTestCase

@property AnalyzeData *analyzeData;

@end

@implementation AnalyzeDataTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.analyzeData = [[AnalyzeData alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitialAllAnalyzeData {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSArray *array = @[@[@"1月",@0],@[@"2月",@0],@[@"3月",@0],@[@"4月",@0],@[@"5月",@0],@[@"6月",@0],@[@"7月",@0],@[@"8月",@0],@[@"9月",@0],@[@"10月",@0],@[@"11月",@0],@[@"12月",@0]];
    [self.analyzeData initialAllAnalyzeData];
    NSLog(@"%@",[self.analyzeData backAnalyzeDataArray]);
    XCTAssertTrue([[self.analyzeData backAnalyzeDataArray] isEqual: array]);
    
}

- (void)testSetAnalyzeDataWithMonth {

    NSArray *array = @[@[@"1月",@0],@[@"2月",@300],@[@"3月",@0],@[@"4月",@0],@[@"5月",@0],@[@"6月",@0],@[@"7月",@0],@[@"8月",@0],@[@"9月",@0],@[@"10月",@0],@[@"11月",@0],@[@"12月",@0]];
    
    [self.analyzeData initialAllAnalyzeData];
    [self.analyzeData setAnalyzeDataWithMonth:2 WithExpense:300];
    XCTAssertTrue([[self.analyzeData backAnalyzeDataArray] isEqual: array]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
