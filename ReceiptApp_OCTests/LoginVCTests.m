//
//  LoginVCTests.m
//  ReceiptApp_OCTests
//
//  Created by Adam Liu on 2022/2/18.
//

#import <XCTest/XCTest.h>
#import "LoginViewController.h"
@import Firebase;

@interface LoginVCTests : XCTestCase

@property LoginViewController *loginVC;

@end

@implementation LoginVCTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.loginVC = [[LoginViewController alloc]init];
    self.loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLoginSuccess {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
