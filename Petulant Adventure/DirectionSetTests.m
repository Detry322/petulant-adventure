//
//  DirectionSetTests.m
//  Petulant Adventure
//
//  Created by Jack Serrino on 10/28/14.
//  Copyright (c) 2014 Jack Serrino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DirectionSet.h"
#import <AFNetworking/AFNetworking.h>

@interface DirectionSetTests : XCTestCase

@end

@implementation DirectionSetTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialization {
    XCTestExpectation *getDirectionsExpectation = [self expectationWithDescription:@"Get Directions"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://maps.googleapis.com/maps/api/directions/json" parameters:@{ @"origin": @"Toronto", @"destination":@"Montreal"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DirectionSet *set = [[DirectionSet alloc] initWithDirectionsData:responseObject];
        XCTAssert(YES);
        [getDirectionsExpectation fulfill];
        NSLog(@"%@",set);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XCTAssert(NO);
        NSLog(@"Error: %@", error);
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testEncodedPointStringToPointArray {
    NSString *leg = @"e`miGhmocNgBf@cBb@KBoFdB[H";
    NSArray *output = [DirectionSet encodedPointStringToPointArray:leg];
    XCTAssert([[output firstObject] coordinate].latitude == 43.65330886840820312500);
    XCTAssert([[output firstObject] coordinate].longitude == -79.38276672363281250000);
    XCTAssert([[output lastObject] coordinate].latitude == 43.65573120117187500000);
    XCTAssert([[output lastObject] coordinate].longitude == -79.38372802734375000000);
}

@end
