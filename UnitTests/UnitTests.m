//
//  UnitTests.m
//  UnitTests
//
//  Created by Alessandro Pricci on 27/04/16.
//  Copyright © 2016 Shore GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Photo.h"

@interface UnitTests : XCTestCase

@end

@implementation UnitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNewPhotoInstance {
    Photo *photo = [[Photo alloc] initWithDictionary:@{@"id": @"123", @"server": @"123",
                                                       @"secret": @"abc123", @"farm": @(2),
                                                       @"title": @"Lorem ipsum dolor sit amet, consectetur adipiscing elit"}];
    XCTAssertNotNil(photo.photoID);
}

- (void)testPhotoURL {
    Photo *photo = [[Photo alloc] initWithDictionary:@{@"id": @"123", @"server": @"123",
                                                       @"secret": @"abc123", @"farm": @(2),
                                                       @"title": @"Lorem ipsum dolor sit amet, consectetur adipiscing elit"}];
    XCTAssertNotNil([photo imageURL]);
}

- (void)testNullPhotoURL {
    Photo *photo = [[Photo alloc] initWithDictionary:@{@"server": @"123",
                                                       @"secret": @"abc123", @"farm": @(2),
                                                       @"title": @"Lorem ipsum dolor sit amet, consectetur adipiscing elit"}];
    XCTAssertNil([photo imageURL]);
}

@end
