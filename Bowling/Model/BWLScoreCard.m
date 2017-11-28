//
//  BWLScoreCard.m
//  Bowling
//
//  Created by Aleksey Drachyov on 11/2/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "BWLScoreCard.h"

@interface BWLScoreCard()


@end

@implementation BWLScoreCard {
    
}
@synthesize playerName=_playerName;
@synthesize score=_score;
+ (NSString*)title {
    return @"Score Card";
}
- (void)setPlayerName:(NSString *)name {
    _playerName=name;
}
- (void)addScore:(NSInteger)score {
    self.score+=score;
}
- (void)printScore{
    NSLog(@"Player - %@ has score %ld",self.playerName,(long)self.score);
}
- (id)initWithName:(NSString*)name {
   self = [super init];
    if(self){
        self.playerName=name;
        
        self.gameScore = [[BWLGameScore alloc]init];
    }
    return self;
}

- (FrameType)updateGameScore:(NSInteger)score withNumberOfGrid:(NSInteger)numberOfGrid andBlock:(void (^)(NSInteger, NSInteger))block {
    if (score == 10) {
        [self.gameScore createFrame:Strike withScore:score withNumberOfGrid:numberOfGrid andBlock:block];
        return Strike;
    } else {
        [self.gameScore createFrame:Frame withScore:score withNumberOfGrid:numberOfGrid andBlock:block];
        return Frame;
    }
    
    
//    if (i == kGridCount) {
//        BWLStrikeFrame *strike = [BWLStrikeFrame new];
//        grid.firstAttempt.text = @"X";
//        self.numberOfGrid++;
//    } else if ([grid.firstAttempt.text intValue] + i == kGridCount) {
//        BWLSpareFrame *spare = [BWLSpareFrame new];
//        grid.secondAttemp.text = @"/";
//        self.numberOfGrid++;
//    } else {
//        BWLFrame *frame = [BWLFrame new];
//
//        frame.score = i;
//        grid.firstAttempt.text = button.titleLabel.text;
//    }
}
@end
