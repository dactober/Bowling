//
//  BWLWinnerOfGame.h
//  Bowling
//
//  Created by admin on 12/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
@interface BWLWinnerOfGame : NSObject <NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
-(id)initWithLocation:(CLLocationCoordinate2D)location;
@end
