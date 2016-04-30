//
//  UITests.m
//  UITests
//
//  Created by Ricardo Borelli on 4/30/16.
//  Copyright © 2016 Shore GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UITests : XCTestCase

@end

@implementation UITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAppNavigation {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *cell = app.collectionViews.cells[[NSString stringWithFormat:@"item_%i", arc4random_uniform(10)]];
    
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == true"];
    
    [self expectationForPredicate:exists evaluatedWithObject:cell handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];
    
    [cell tap];
    
    XCUIElement *detailsTitle = app.staticTexts[@"details_title"];
    
    [self expectationForPredicate:exists evaluatedWithObject:detailsTitle handler:nil];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
    XCUIElement *closeButton = app.buttons[@"close_details"];
    
    [self expectationForPredicate:exists evaluatedWithObject:closeButton handler:nil];
    [self waitForExpectationsWithTimeout:25 handler:nil]; // long timeout because we need to wait the dynamics animation finish first
    
    [closeButton tap];
    
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"exists == false"] evaluatedWithObject:detailsTitle handler:nil];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
