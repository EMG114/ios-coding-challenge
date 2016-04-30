//
//  Photo.m
//  InterviewTest
//
//  Created by Ricardo Borelli on 4/30/16.
//  Copyright © 2016 Shore GmbH. All rights reserved.
//

#import "Photo.h"
#import "FlickrKit.h"

@implementation Photo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.photoID = dictionary[@"id"];
        self.server = dictionary[@"server"];
        self.secret = dictionary[@"secret"];
        self.farm = dictionary[@"farm"];
        self.title = dictionary[@"title"];
    }
    
    return self;
}

- (NSURL * _Nullable)imageURL {
    @try {
        NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240
                                                          photoID:self.photoID server:self.server
                                                           secret:self.secret farm:[self.farm stringValue]];
        
        return url;
    } @catch (NSException *exception) {
        return nil;
    }
}

@end
