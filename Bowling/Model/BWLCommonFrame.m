//
//  BWLCommonFrame.m
//  Bowling
//
//  Created by admin on 11/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLCommonFrame.h"

@interface BWLCommonFrame()
@property (nonatomic, strong) NSMutableArray *scoreList;
@end

@implementation BWLCommonFrame

static int const kFrameAttemp = 1;

- (instancetype)initWithScore:(NSInteger)score index:(NSInteger)index {
    self = [super init];
    if (self) {
        self.scoreList = [NSMutableArray new];
        [self addScore:score];
        _index = index;
    }
    return self;
}

- (BowlingFrameType)type {
    if (self.score != 10) {
        if (self.attemp == kFrameAttemp) {
            return BowlingFrameStandartFrame;
        } else if (self.attemp == 2) {
            return BowlingFrameSpare;
        }
    }
    return BowlingFrameStrike;
}

- (NSInteger)attemp {
    return [self.scoreList count];
}

- (void)addScore:(NSInteger)score {
    [self.scoreList addObject:@(score)];
}

- (NSInteger)score {
    NSInteger sum = 0;
    for (NSNumber *score in self.scoreList) {
        sum += score.integerValue;
    }
    return sum;
}

@end
