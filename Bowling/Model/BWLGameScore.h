//
//  BWLGameScore.h
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWLCommonFrame.h"


@interface BWLGameScore : NSObject
@property (nonatomic) NSInteger score;
- (BowlingFrameType)addBowlingFrameWithScore:(NSInteger)score index:(NSInteger)index block:(void (^)(NSInteger, NSInteger))block;
@end
