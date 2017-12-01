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
static int const kSpare = 10;
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
    NSArray *strikeList = [NSArray arrayWithArray:self.currentStrikeSequence];
    NSArray *spareList = [NSArray arrayWithArray:self.curentSpareSequence];
    BWLCommonFrame *commonFrame = [[BWLCommonFrame alloc]initWithScore:score index:index];
    if (commonFrame.type == BowlingFrameStrike) {
        [self updateFrameWithSequence:strikeList score:score isStrike:YES withBlock:block];
        [self updateFrameWithSequence:spareList score:score isStrike:NO withBlock:block];
        [self.currentStrikeSequence addObject:commonFrame];
    } else {
        if (self.commonBowlingFrame == nil) {
            self.commonBowlingFrame = commonFrame;
        } else {
            [self.commonBowlingFrame addScore:score];
            if (self.commonBowlingFrame.score == kSpare) {
                BWLCommonFrame *spareFrame = self.commonBowlingFrame;
                [self.curentSpareSequence addObject:spareFrame];
                isSpare = YES;
            }
        }
        [self updateStandartBowlingFrame:score index:index isSpare:isSpare withBlock:block];
    }
    return commonFrame.type;
}

- (void)updateStandartBowlingFrame:(NSInteger)score index:(NSInteger)index isSpare:(BOOL)isSpare withBlock:(void (^)(NSInteger, NSInteger))block {
    NSArray *strikeList = [NSArray arrayWithArray:self.currentStrikeSequence];
    [self updateFrameWithSequence:strikeList score:score isStrike:YES withBlock:block];
    if (!isSpare) {
        NSArray *spareList = [NSArray arrayWithArray:self.curentSpareSequence];
        [self updateFrameWithSequence:spareList score:self.commonBowlingFrame.score isStrike:NO withBlock:block];
    }
    if (self.commonBowlingFrame.attemp == kLastFrameAttemp) {
        if (!isSpare) {
            block(self.commonBowlingFrame.score, index);
        }
        self.commonBowlingFrame = nil;
    }
}

- (void)updateFrameWithSequence:(NSArray *)array score:(NSInteger)score isStrike:(BOOL)isStrike withBlock:(void (^)(NSInteger, NSInteger))block {
    for (BWLCommonFrame *frame in array) {
        [frame addScore:score];
        if (frame.attemp == kLastAttemp) {
            block(frame.score, frame.index);
            if (isStrike) {
                [self.currentStrikeSequence removeObject:frame];
            } else {
                [self.curentSpareSequence removeObject:frame];
            }
            
        }
    }
}

@end
