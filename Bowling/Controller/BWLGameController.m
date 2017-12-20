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
#import "BWLResultController.h"
@interface BWLGameController ()
@property (strong, nonatomic) NSArray *playersCards;
@property (strong, nonatomic) NSMutableArray *playersGames;
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
    self.gameScrollView.minimumZoomScale = 1;
    self.gameScrollView.maximumZoomScale = 4;
    self.gameScrollView.zoomScale = 1;
    self.gameScrollView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    BWLPlayerViewController *playerViewController = self.playersGames[0];
    return playerViewController.view;
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
    self.gameScrollView = [UIScrollView new];
}

- (void)addViews {
    for(int i = 0;i < self.playersCards.count;i++) {
        BWLScoreCard *scoreCard = self.playersCards[i];
        if (i < self.playersCards.count - 1) {
            [self addPlayerViewController:scoreCard isLastView:NO];
        } else {
            [self addPlayerViewController:scoreCard isLastView:YES];
        }
    }
}

- (void)addConstraintForScrollView {
    self.gameScrollView.keepTopInset.equal = KeepRequired(0);
    self.gameScrollView.keepBottomInset.equal = KeepRequired(0);
    self.gameScrollView.keepLeftInset.equal = KeepRequired(0);
    self.gameScrollView.keepRightInset.equal = KeepRequired(0);
}

- (void)addPlayerViewController:(BWLScoreCard *)scoreCard isLastView:(BOOL)isLastView{
    BWLPlayerViewController *playerController = [[BWLPlayerViewController alloc]initWithPlayer:scoreCard andFinishBlock:^{
        if ([self isGameEnd]) {
            [self presentResultViewController];
        }
    }];
    [self.gameScrollView addSubview:playerController.view];
    if (!self.playersGames.count) {
        [self addConstrainsBetweenPrevView:nil andView:playerController.view isLastView:isLastView];
    } else {
        BWLPlayerViewController *prev = [self.playersGames lastObject];
        [self addConstrainsBetweenPrevView:prev.view andView:playerController.view isLastView:isLastView];
    }
    [playerController fillPlayerViewController];
    [self.playersGames addObject:playerController];
    [self addLabelForPlayerViewController:playerController withScoreCard:scoreCard];
}

- (void)presentResultViewController {
    BWLResultController *resultViewController = [[BWLResultController alloc]initWithScoreCards:self.playersCards winner:self.winner andAnnotation:self.annotation];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

- (BOOL)isGameEnd {
    for (BWLPlayerViewController *playerViewController in self.playersGames) {
        if (!playerViewController.isGameEnd) {
            return NO;
        }
    }
    return YES;
}

- (void)addLabelForPlayerViewController:(BWLPlayerViewController *)playerViewController withScoreCard:(BWLScoreCard *)scoreCard {
    UILabel *label =  [UILabel new];
    [label  setFont:[UIFont systemFontOfSize:15]];
    [self.gameScrollView addSubview:label];
    label.text = scoreCard.playerName;
    [self addConstraintForLabel:label andView:playerViewController.view];
}

- (void)addConstrainsBetweenPrevView:(UIView *)prevView andView:(UIView *)view isLastView:(BOOL)isLastView {
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

- (void)addConstraintForLabel:(UILabel *)name andView:(UIView *)view {
    name.keepBottomOffsetTo(view).equal = KeepRequired(0);
    name.keepLeftInset.equal = KeepRequired(kLeadingOffset + 10);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
