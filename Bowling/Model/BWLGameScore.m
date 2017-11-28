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
@property (nonatomic, strong)BWLStrikeFrame *strikeFrame;
@property (nonatomic, strong)NSMutableArray *strikeFrames;
@property (nonatomic, strong)BWLFrame *frame;
@property (nonatomic, strong)BWLSpareFrame *spareFrame;
@property (nonatomic, strong)NSMutableArray *spareFrames;
@end

@implementation BWLGameScore

- (instancetype)init {
    self = [super init];
    if (self) {
        self.strikeFrames = [NSMutableArray new];
        self.spareFrames = [NSMutableArray new];
    }
    return self;
}

- (void)createFrame:(FrameType)frameType withScore:(NSInteger)score withNumberOfGrid:(NSInteger)numberOfGrid andBlock:(void (^)(NSInteger, NSInteger))block {
    
    switch (frameType) {
        case Strike: {
            for (int i = 0;i < self.strikeFrames.count;i++) {
                BWLStrikeFrame *frame = self.strikeFrames[i];
                frame.attemp += 1;
                frame.score += 10;
                if (frame.attemp == 3) {
                    block(frame.score, frame.numberOfGrid);
                }
                
            }
                self.strikeFrame = [BWLStrikeFrame new];
                [self.strikeFrames addObject:self.strikeFrame];
                self.strikeFrame.score = 10;
                self.strikeFrame.numberOfGrid = numberOfGrid;
                self.strikeFrame.attemp += 1;
                break;
        }
        case Spare: {
            
            break;
        }
        case Frame: {
            if (self.frame == nil) {
                self.frame = [BWLFrame new];
                
                self.frame.firstScore = score;
            } else {
                self.frame.secondScore = score;
                if (self.frame.firstScore + self.frame.secondScore == 10) {
                    self.spareFrame = [BWLSpareFrame new];
                    [self.spareFrames addObject:self.spareFrame];
                    self.spareFrame.attemp = 2;
                    self.spareFrame.numberOfGrid = numberOfGrid;
                }
            }
            
            self.frame.score += score;
            self.frame.attemp +=1;
           
            if (self.spareFrames.count != 0) {
                for (int i = 0;i < self.spareFrames.count;i++) {
                    BWLSpareFrame *frame = self.spareFrames[i];
                    frame.attemp += 1;
                    frame.score += score;                           //spare
                    if (frame.attemp == 3) {
                        block(frame.score, frame.numberOfGrid);
                    }
                }
            }
            
            if (self.strikeFrames.count != 0) {
                for (int i = 0;i < self.strikeFrames.count;i++) {
                    BWLStrikeFrame *frame = self.strikeFrames[i];
                    frame.attemp += 1;
                    frame.score += score;
                    if (frame.attemp == 3) {
                        block(frame.score, frame.numberOfGrid);
                    }
                }
            }
            
            if (self.frame.attemp == 2) {
                block(self.frame.score, numberOfGrid);
                self.frame = nil;
            }
            break;
        }
        default:
            break;
    }
    

}

- (void)updateFrame {
    
}

@end
