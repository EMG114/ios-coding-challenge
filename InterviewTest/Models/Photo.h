//
//  Photo.h
//  InterviewTest
//
//  Created by Ricardo Borelli on 4/30/16.
//  Copyright © 2016 Shore GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface Photo : NSObject

@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *secret;
@property (strong, nonatomic) NSNumber *farm;
@property (strong, nonatomic) NSString *title;

/**
 *  Create a new instance of the class
 *
 *  @param dictionary Dictionary with data from Flickr
 *
 *  @return class instance
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Return the URL with the image
 *
 *  @return NSURL or nil
 */
- (NSURL * _Nullable)imageURL;

@end
NS_ASSUME_NONNULL_END
