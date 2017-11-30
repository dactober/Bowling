//
//  BWLPlayerViewController.m
//  Bowling
//
//  Created by admin on 11/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLPlayerViewController.h"
#import "BWLPlayerViewController+ViewConstraints.h"
#import "BWLScoreInputView.h"
#import "BWLTopButtonsComponent.h"
#import "BWLBottomButonsComponent.h"
#import "BWLStrikeFrame.h"
#import "BWLSpareFrame.h"
#import "BWLFrame.h"

typedef NS_ENUM (NSInteger, ButtonType) {
    TopButtonType,
    BottomButtonType
    
};

typedef void (^ButtonBlock)(UIButton *);
@interface BWLPlayerViewController ()
@property (strong, nonatomic) BWLScoreGridView *scoreGridView;
@property (strong, nonatomic) BWLScoreGridResultView *scoreGridResultView;
@property (strong, nonatomic) BWLScoreCard *playerCard;
@property (strong, nonatomic) NSMutableArray *views;
@property (strong, nonatomic) NSMutableDictionary *buttons;
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSDictionary *titlesForButtonsMapping;
@end

@implementation BWLPlayerViewController

const static int kGridCount = 10;
const static int kLastGridIndex = kGridCount - 1;
const static int kSpare = 10;
- (id)initWithPlayer:(BWLScoreCard *)card {
    self = [super init];
    if (self) {
        self.playerCard = card;
        
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.playerView = [[BWLPlayerView alloc]init];
    [self.playerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.index = 0;
    self.views = [NSMutableArray new];
    self.buttons = [NSMutableDictionary new];
}

- (NSDictionary *)titlesForButtonsMapping {
    if (!_titlesForButtonsMapping) {
        _titlesForButtonsMapping = @{@(TopButtonType)  : @[@"0",@"1",@"2",@"3",@"4",@"5"],
                                     @(BottomButtonType) : @[@"6",@"7",@"8",@"9",@"10"]};
    }
    return _titlesForButtonsMapping;
}

- (void)addPlayer {
    [self addBowlingFrames];
    [self addContainerWithType:TopButtonType];
    [self addContainerWithType:BottomButtonType];
}

- (void)addBowlingFrames {
    for (int i = 0; i < kGridCount; i++) {
        if(i == kLastGridIndex) {
            BWLScoreGridResultView *grid = [self createLastFrameWithPrevView:[self.views lastObject]];
            [self.views addObject:grid];
        } else {
            BWLScoreGridView *grid = [self createFrameWithPrevView:[self.views lastObject]];
            [self.views addObject:grid];
        }
    }
    [self.views keepWidthsEqual];
    [self.views keepHeightsEqual];
}

- (BWLScoreGridResultView *)createLastFrameWithPrevView:(BWLScoreGridView *)prevView {
    BWLScoreGridResultView* grid = [[BWLScoreGridResultView alloc] init];
    [self.playerView addSubview: grid];
    [self addConstraintsForResultGridView:grid andPrevView:prevView];
    return grid;
}

- (BWLScoreGridView *)createFrameWithPrevView:(BWLScoreGridView *)prevView  {
    BWLScoreGridView *grid = [[BWLScoreGridView alloc]init] ;
    [self.playerView addSubview:grid];
    [self updateConstraintsBetweenPrevScoreGridView:prevView andScoreGridView:grid];
    return grid;
}

- (void)addContainerWithType:(ButtonType)buttonType {
    UIView *containerView = [self createContainerView];
    [self.playerView addSubview:containerView];
    [self updateConstraintsForContainerView:containerView];
    if (buttonType == BottomButtonType) {
        containerView.keepBottomInset.equal = KeepRequired(0);
        [self topOffsetBetweenContainerView:self.containerView andContainerViewForKeep:containerView];
    } else {
        containerView.keepTopOffsetTo(self.views[0]).equal = KeepRequired(5);
        self.containerView = containerView;
    }
    [self addButtonsWithType:buttonType andContainerView:containerView];
    self.buttons[@(buttonType)] = containerView;
}

- (UIView *)createContainerView {
    UIView * view = [[UIView alloc]init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    return view;
}

- (void)addButtonsWithType:(ButtonType)buttonType andContainerView:(UIView *)containerView {
    __weak typeof(self) _self_weak = self;
    ButtonBlock buttonBlock = ^(UIButton *button) {
        [_self_weak fillBowlingFrame:button];
    };
    BWLButtonsComponent *buttonComponent = [[BWLTopButtonsComponent alloc] initWithContainerView:containerView titles:self.titlesForButtonsMapping[@(buttonType)] withBlock:buttonBlock];
    [buttonComponent addBWLButtons];
}

- (void)fillBowlingFrame:(UIButton *)button {
    NSInteger score = [button.titleLabel.text intValue];
    if (self.index < kLastGridIndex) {
        BWLScoreGridView *grid = self.views[self.index];
        if (grid.score + score <= kSpare) {
            grid.score += score;
            [self fillGridView:score withScoreGridView:grid];
        } else return;
    } else {
        BWLScoreGridResultView *grid = self.views[self.index];
        [self fillGridResultView:score withScoreGridResultView:grid];
    }
}

- (void)fillGridView:(NSInteger)score withScoreGridView:(BWLScoreGridView *)grid {
    BowlingFrameType type =  [self.playerCard updateGameScore:score  withIndex:self.index andBlock:^(NSInteger score, NSInteger index) {
        [self fillResult:score index:index];
    }];
    if (type == Strike) {
        [grid setFirstAttemptScore:score];//
        self.index++;
    }
    if (type == Frame) {
        if ([grid isEmptyFirstAttemp]) {
            [grid setFirstAttemptScore:score];
        } else {
            [grid setSecondAttemptScore:score];
            self.index++;
        }
    }
}

- (void)fillGridResultView:(NSInteger)score withScoreGridResultView:(BWLScoreGridResultView *)grid {
    BowlingFrameType type =  [self.playerCard updateGameScore:score  withIndex:self.index andBlock:^(NSInteger score, NSInteger index) {
        [self fillResultForGridResult:score index:index];
    }];
    if (type == Strike) {
        if ([grid isEmptyFirstAttemp]) {
            grid.score += score;
            [grid setFirstAttempScore:score];
        } else if ([grid isEmptySecondAttemp]){
            [grid setSecondAttempScore:score];//
        } else {
            [grid setThirdAttempScore:score];
            [self hideContainers];
        }
    }
    if (type == Frame) {
        if ([grid isEmptyFirstAttemp]) {
            [grid setFirstAttempScore:score];
            grid.score += score;
        } else if ([grid isEmptySecondAttemp]) {
            [grid setSecondAttempScore:score];
            grid.score += score;
            if (grid.score < kSpare) {
                [self hideContainers];
            }
        } else {
            [grid setThirdAttempScore:score];
            [self hideContainers];
        }
    }
}

- (void)fillResult:(NSInteger)score index:(NSInteger)index{
    BWLScoreGridView *grid = self.views[index];
    self.playerCard.score += score;
    [grid setResultScore:self.playerCard.score];
}

- (void)fillResultForGridResult:(NSInteger)score index:(NSInteger)index{
    BWLScoreGridResultView *grid = self.views[index];
    self.playerCard.score += score;
    [grid setResultScore:self.playerCard.score];
}

- (void)hideContainers {
    UIView *firstContainer = self.buttons[@(TopButtonType)];
    UIView *secondContainer = self.buttons[@(BottomButtonType)];
    firstContainer.hidden = YES;
    secondContainer.hidden = YES;
    [self addResultLabel];
}

- (void)addResultLabel {
    UILabel *label = [UILabel new];
    [self.playerView addSubview:label];
    label.keepTopOffsetTo([self.views firstObject]).equal = KeepRequired(0);
    label.text = [NSString stringWithFormat:@"%ld",(long)self.playerCard.score];
}

@end
