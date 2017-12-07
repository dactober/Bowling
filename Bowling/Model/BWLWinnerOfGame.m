//
//  BWLWinnerOfGame.m
//  Bowling
//
//  Created by admin on 12/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLWinnerOfGame.h"

@implementation BWLWinnerOfGame

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.score = [decoder decodeObjectForKey:@"score"];
        self.longitude = [decoder decodeObjectForKey:@"longitude"];
        self.latitude = [decoder decodeObjectForKey:@"latitude"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.score forKey:@"score"];
    [encoder encodeObject:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.latitude forKey:@"latitude"];
}

-(id)initWithLocation:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self) {
        self.longitude = @(location.longitude);
        self.latitude = @(location.latitude);
    }
    return self;
}

@end
