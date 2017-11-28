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

@property (strong, nonatomic) NSArray *playersCards;
@property (strong, nonatomic) NSMutableArray *playersGames;
@property (strong, nonatomic) BWLPlayerViewController *player;
@property (strong, nonatomic) NSMutableArray *views;
@property (strong, nonatomic) UILabel *nameOfPlayer;
@property (strong, nonatomic) UIScrollView *gameScrollView;
@end

@implementation BWLGameController
const static int kLeadingOffset = 0;
const static int kTrailingOffset = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.gameScrollView];
    [self addConstraintForScrollView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addViews];
}

- (void)addViews {
    for(int i = 0;i < self.playersCards.count;i++) {
        if (i < self.playersCards.count - 1) {
            [self addView:i isLastView:NO];
        } else {
            [self addView:i isLastView:YES];
        }
    }
}

- (void)addConstraintForScrollView {
    self.gameScrollView.keepTopInset.equal = KeepRequired(0);
    self.gameScrollView.keepBottomInset.equal = KeepRequired(0);
    self.gameScrollView.keepLeftInset.equal = KeepRequired(0);
    self.gameScrollView.keepRightInset.equal = KeepRequired(0);
}

- (void)addView:(NSInteger )i isLastView:(BOOL)isLastView{
    self.player = [[BWLPlayerViewController alloc]initWithPlayer:self.playersCards[i]];
    [self.gameScrollView addSubview:self.player.playerView];
    if (i == 0) {
        [self addConstrainsBetweenPrevView:nil andView:self.player.playerView isLastView:isLastView];
    } else {
        BWLPlayerViewController *prev = [self.playersGames lastObject];
        [self addConstrainsBetweenPrevView:prev.playerView andView:self.player.playerView isLastView:isLastView];
    }
    [self.player addPlayer];
    [self.playersGames addObject:self.player];
    [self.views addObject:self.player.playerView];
    self.nameOfPlayer = [self createLabel];
    BWLScoreCard *card = self.playersCards[i];
    self.nameOfPlayer.text = card.playerName;
    [self addConstraintForLabel:self.nameOfPlayer andView:self.player.playerView];
}

- (UILabel *)createLabel {
   UILabel *label =  [UILabel new];
    [label  setFont:[UIFont systemFontOfSize:15]];
    [self.gameScrollView addSubview:label];
    return label;
}

- (void)addConstrainsBetweenPrevView:(BWLPlayerView *)prevView andView:(BWLPlayerView *)view isLastView:(BOOL)isLastView{
    if(prevView == nil) {
        view.keepTopInset.equal = KeepRequired(20);
        view.keepLeftInset.equal = KeepRequired(kLeadingOffset);
        view.keepRightInset.equal = KeepRequired(kTrailingOffset);
        NSArray *equalList = @[view, self.gameScrollView];
        [equalList keepWidthsEqual];
    } else {
        if (isLastView) {
            view.keepBottomInset.equal = KeepRequired(0);
        }
        view.keepTopOffsetTo(prevView).equal = KeepRequired(15);
        view.keepLeftInset.equal = KeepRequired(kLeadingOffset);
        view.keepRightInset.equal = KeepRequired(kTrailingOffset);
    }
}

- (void)addConstraintForLabel:(UILabel *)name andView:(BWLPlayerView *)view {
    name.keepBottomOffsetTo(view).equal = KeepRequired(0);
    name.keepLeftInset.equal = KeepRequired(kLeadingOffset + 10);
}

- (id)initWithScoreCards:(NSArray *)playersCards {
    self = [super init];
    if (self) {
        self.playersCards = playersCards;

        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.playersGames = [NSMutableArray new];
    self.views = [NSMutableArray new];
    self.gameScrollView = [UIScrollView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
