//
//  BWLGameScore.h
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, BowlingFrameType) {
    Strike,
    Spare,
    Frame
    
};

@interface BWLGameScore : NSObject
@property (nonatomic) NSInteger score;
- (void)addBowlingFrame:(BowlingFrameType)frameType withScore:(NSInteger)score withIndex:(NSInteger)index andBlock:(void(^)(NSInteger, NSInteger))block;
@end
