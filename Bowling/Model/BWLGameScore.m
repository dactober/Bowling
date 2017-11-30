//
//  BWLGameScore.m
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "BWLGameScore.h"

#import "BWLFrame.h"
#import "BWLSpareFrame.h"

@interface BWLGameScore ()
@property (nonatomic, strong)NSMutableArray<BWLCommonFrame *> *currentStrikeSequence;
@property (nonatomic, strong)BWLFrame *frame;
@property (nonatomic, strong)NSMutableArray<BWLCommonFrame *> *curentSpareSequence;
@property (nonatomic, strong)BWLCommonFrame *commonBowlingFrame;
@end

@implementation BWLGameScore
static int const kStrike = 10;
static int const kLastAttemp = 3;
static int const kLastFrameAttemp = kLastAttemp - 1;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentStrikeSequence = [NSMutableArray new];
        self.curentSpareSequence = [NSMutableArray new];
    }
    return self;
}

- (BowlingFrameType)addBowlingFrameWithScore:(NSInteger)score index:(NSInteger)index andBlock:(void (^)(NSInteger, NSInteger))block {
    BOOL isSpare = NO;
    BWLCommonFrame *commonFrame = [[BWLCommonFrame alloc]initWithScore:score index:index];
    if (commonFrame.type == Strike) {
        [self updateStrikeFrame:score withBlock:block];
        [self updateSpareFrame:score withBlock:block];
        [self.currentStrikeSequence addObject:commonFrame];
    } else {
        if (self.commonBowlingFrame == nil) {
            self.commonBowlingFrame = commonFrame;
        } else {
            [self.commonBowlingFrame addScore:score];
            if (self.commonBowlingFrame.score == kStrike) {
                BWLCommonFrame *spareFrame = self.commonBowlingFrame;
                [self.curentSpareSequence addObject:spareFrame];
                isSpare = YES;
            }
        }
        [self updateBowlingFrame:score index:index isSpare:isSpare withBlock:block];
    }
    return commonFrame.type;
}

- (void)updateBowlingFrame:(NSInteger)score index:(NSInteger)index isSpare:(BOOL)isSpare withBlock:(void (^)(NSInteger, NSInteger))block {
    [self updateStrikeFrame:score withBlock:block];
    if (!isSpare) {
        [self updateSpareFrame:self.commonBowlingFrame.score withBlock:block];
    }
    if (self.commonBowlingFrame.attemp == kLastFrameAttemp) {
        if (!isSpare) {
            block(self.commonBowlingFrame.score, index);
        }
        self.commonBowlingFrame = nil;
    }
}

- (void)updateStrikeFrame:(NSInteger)score withBlock:(void (^)(NSInteger, NSInteger))block {
    NSArray *strikeList = [NSArray arrayWithArray:self.currentStrikeSequence];
    for (BWLCommonFrame *frame in strikeList) {
        [frame addScore:score];
        if (frame.attemp == kLastAttemp) {
            block(frame.score, frame.index);
            [self.currentStrikeSequence removeObject:frame];
        }
    }
}

- (void)updateSpareFrame:(NSInteger)score withBlock:(void (^)(NSInteger, NSInteger))block {
    NSArray *spareList = [NSArray arrayWithArray:self.curentSpareSequence];
    for (BWLCommonFrame *frame in spareList) {
        [frame addScore:score];
        if (frame.attemp == kLastAttemp) {
            block(frame.score, frame.index);
            [self.curentSpareSequence removeObject:frame];
        }
    }
}

@end
