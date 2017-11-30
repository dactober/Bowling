//
//  BWLGameScore.m
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "BWLGameScore.h"
#import "BWLStrikeFrame.h"
#import "BWLFrame.h"
#import "BWLSpareFrame.h"
@interface BWLGameScore ()
@property (nonatomic, strong)NSMutableArray<BWLStrikeFrame *> *currentStrikeSequence;
@property (nonatomic, strong)BWLFrame *frame;
@property (nonatomic, strong)NSMutableArray<BWLSpareFrame *> *curentSpareSequence;
@end

@implementation BWLGameScore
static int const kStrike = 10;
static int const kLastAttemp = 3;
static int const kLastFrameAttemp = kLastAttemp - 1;
static int const kFirstFrameAttemp = 1;
static int const kOneFrameAttemp = 1;
- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentStrikeSequence = [NSMutableArray new];
        self.curentSpareSequence = [NSMutableArray new];
    }
    return self;
}

- (void)addBowlingFrame:(BowlingFrameType)bowlingFrameType withScore:(NSInteger)score withIndex:(NSInteger)index andBlock:(void (^)(NSInteger, NSInteger))block {
    switch (bowlingFrameType) {
        case Strike: {
            [self updateStrikeFrame:score withBlock:block];
            [self updateSpareFrame:score withBlock:block];
            BWLStrikeFrame *strikeFrame = [BWLStrikeFrame new];
            [self.currentStrikeSequence addObject:strikeFrame];
            strikeFrame.score = score;
            strikeFrame.index = index;
            strikeFrame.attemp += kOneFrameAttemp;
            break;
        }
        case Frame: {
            if (self.frame == nil) {
                self.frame = [BWLFrame new];
                self.frame.firstScore = score;
            } else {
                self.frame.secondScore = score;
                if (self.frame.firstScore + self.frame.secondScore == kStrike) {
                    BWLSpareFrame *spareFrame = [self createSpareFrame:index];
                    [self.curentSpareSequence addObject:spareFrame];
                }
            }
            [self updateBowlingFrame:score index:index withBlock:block];
            break;
        }
        default:
            break;
    }
}

- (BWLSpareFrame *)createSpareFrame:(NSInteger)index {
    BWLSpareFrame *spareFrame = [BWLSpareFrame new];
    spareFrame.attemp = kFirstFrameAttemp;
    spareFrame.index = index;
    return spareFrame;
}

- (void)updateBowlingFrame:(NSInteger)score index:(NSInteger)index withBlock:(void (^)(NSInteger, NSInteger))block{
    self.frame.score += score;
    self.frame.attemp += kOneFrameAttemp;
    [self updateStrikeFrame:score withBlock:block];
    [self updateSpareFrame:self.frame.score withBlock:block];
    if (self.frame.attemp == kLastFrameAttemp) {
        if (self.curentSpareSequence.count == 0) {
            block(self.frame.score, index);
        }
        self.frame = nil;
    }
}

- (void)updateStrikeFrame:(NSInteger)score withBlock:(void (^)(NSInteger, NSInteger))block{
    for (int i = 0;i < self.currentStrikeSequence.count;i++) {
        BWLStrikeFrame *frame = self.currentStrikeSequence[i];
        frame.attemp += kOneFrameAttemp;
        frame.score += score;
        if (frame.attemp == kLastAttemp) {
            block(frame.score, frame.index);
            [self.currentStrikeSequence removeObjectAtIndex:i];
            i--;
        }
    }
}

- (void)updateSpareFrame:(NSInteger)score withBlock:(void (^)(NSInteger, NSInteger))block{
    for (int i = 0;i < self.curentSpareSequence.count;i++) {
        BWLSpareFrame *frame = self.curentSpareSequence[i];
        frame.attemp += kOneFrameAttemp;
        frame.score += score;
        if (frame.attemp == kLastAttemp) {
            block(frame.score, frame.index);
            [self.curentSpareSequence removeObjectAtIndex:i];
        }
    }
}

@end
