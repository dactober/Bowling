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

@implementation BWLScoreCard

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

- (BowlingFrameType)updateGameScore:(NSInteger)score withIndex:(NSInteger)index block:(void (^)(NSInteger, NSInteger))block {
        return [self.gameScore addBowlingFrameWithScore:score index:index block:block];
}
@end
