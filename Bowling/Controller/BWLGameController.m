//
//  ViewController.m
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLGameController.h"
#import "BWLPlayerViewController.h"
#import "KeepLayout.h"
#import "BWLScoreCard.h"

@interface BWLGameController ()

@property (strong,nonatomic) NSArray *playersCards;
@property (strong, nonatomic)NSMutableArray *playersGames;
@property (strong, nonatomic)BWLPlayerViewController *player;
@property (strong, nonatomic)NSMutableArray *views;
@property (strong, nonatomic)UILabel *nameOfPlayer;
@property (strong, nonatomic)UIScrollView *gameScrollView;
@end

@implementation BWLGameController
const static int kLeadingOffset = 0;
const static int kTrailingOffset = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.playersGames = [NSMutableArray new];
    self.views = [NSMutableArray new];
    self.gameScrollView = [UIScrollView new];
    [self.view addSubview:self.gameScrollView];
    self.gameScrollView.keepTopInset.equal = KeepRequired(0);
    self.gameScrollView.keepBottomInset.equal = KeepRequired(0);
    self.gameScrollView.keepLeftInset.equal = KeepRequired(0);
    self.gameScrollView.keepRightInset.equal = KeepRequired(0);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    for(int i = 0;i < self.playersCards.count;i++) {
        if (i < self.playersCards.count - 1) {
            [self createView:i isLastView:NO];
        } else {
            [self createView:i isLastView:YES];
        }
        
    }
//    [self.views addObject:self.gameScrollView];
//    [self.views keepWidthsEqual];
//    [self.views removeLastObject];
//    [self.views keepHeightsEqual];
    
}

- (void)createView:(NSInteger )i isLastView:(BOOL)isLastView{
    self.player = [[BWLPlayerViewController alloc]initWithPlayer:self.playersCards[i]];
    [self.gameScrollView addSubview:self.player.playerView];
    if (i == 0) {
        [self createConstrainsBetweenView:nil andSecondView:self.player.playerView isLastView:isLastView];
    } else {
        BWLPlayerViewController *prev = [self.playersGames lastObject];
        [self createConstrainsBetweenView:prev.playerView andSecondView:self.player.playerView isLastView:isLastView];
    }
    [self.player createGameForPlayer];
    [self.playersGames addObject:self.player];
    [self.views addObject:self.player.playerView];
    
    self.nameOfPlayer = [self createLabel];
    BWLScoreCard *card = self.playersCards[i];
    self.nameOfPlayer.text = card.playerName;
    [self createConstraintForLabel:self.nameOfPlayer andView:self.player.playerView];
}

- (UILabel *)createLabel {
   UILabel *label =  [UILabel new];
    [label  setFont:[UIFont systemFontOfSize:15]];
    [self.gameScrollView addSubview:label];
    return label;
}

- (void)createConstrainsBetweenView:(BWLPlayerView *)firstView andSecondView:(BWLPlayerView *)secondView isLastView:(BOOL)isLastView{
    if(firstView == nil) {
        secondView.keepTopInset.equal = KeepRequired(20);
        secondView.keepLeftInset.equal = KeepRequired(kLeadingOffset);
        secondView.keepRightInset.equal = KeepRequired(kTrailingOffset);
        NSArray *equalList = @[secondView, self.gameScrollView];
        [equalList keepWidthsEqual];
    } else {
        if (isLastView) {
            secondView.keepBottomInset.equal = KeepRequired(0);
        }
        secondView.keepTopOffsetTo(firstView).equal = KeepRequired(15);
        secondView.keepLeftInset.equal = KeepRequired(kLeadingOffset);
        secondView.keepRightInset.equal = KeepRequired(kTrailingOffset);
    }
   
    
}

- (void)createConstraintForLabel:(UILabel *)name andView:(BWLPlayerView *)view {
    name.keepBottomOffsetTo(view).equal = KeepRequired(0);
    name.keepLeftInset.equal = KeepRequired(kLeadingOffset + 10);
}

- (id)initWithScoreCards:(NSArray *)playersCards {
    self = [super init];
    if (self) {
        self.playersCards = playersCards;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
