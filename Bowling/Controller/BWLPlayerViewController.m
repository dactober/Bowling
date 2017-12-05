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

typedef NS_ENUM (NSInteger, ButtonType) {
    TopButtonType,
    BottomButtonType
    
};

typedef void (^ButtonBlock)(UIButton *);
typedef void (^FinishBlock)(void);
@interface BWLPlayerViewController ()
@property (nonatomic, copy) FinishBlock finishBlock;
@property (strong, nonatomic) BWLScoreGridView *scoreGridView;
@property (strong, nonatomic) BWLScoreGridResultView *scoreGridResultView;
@property (strong, nonatomic) BWLScoreCard *playerCard;
@property (strong, nonatomic) NSMutableArray *frameViews;
@property (strong, nonatomic) NSMutableDictionary *buttons;
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSDictionary *titlesForButtonsMapping;
@end

@implementation BWLPlayerViewController

const static int kGridCount = 10;
const static int kLastGridIndex = kGridCount - 1;
const static int kSpare = 10;
- (id)initWithPlayer:(BWLScoreCard *)card andFinishBlock:(void (^)(void))finishBlock{
    self = [super init];
    if (self) {
        self.playerCard = card;
        
        [self customInitWithBlock:finishBlock];
        
    }
    return self;
}

- (void)customInitWithBlock:(void (^)(void))finishBlock{
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.index = 0;
    self.frameViews = [NSMutableArray new];
    self.buttons = [NSMutableDictionary new];
    self.finishBlock = finishBlock;
    self.isGameEnd = NO;
}

- (NSDictionary *)titlesForButtonsMapping {
    if (!_titlesForButtonsMapping) {
        _titlesForButtonsMapping = @{@(TopButtonType)  : @[@"0",@"1",@"2",@"3",@"4",@"5"],
                                     @(BottomButtonType) : @[@"6",@"7",@"8",@"9",@"10"]};
    }
    return _titlesForButtonsMapping;
}

- (void)fillPlayerViewController {
    [self addBowlingFrames];
    [self addContainerWithType:TopButtonType];
    [self addContainerWithType:BottomButtonType];
}

- (void)addBowlingFrames {
    for (int i = 0; i < kGridCount; i++) {
        if(i == kLastGridIndex) {
            BWLScoreGridResultView *grid = [self createLastFrameWithPrevView:[self.frameViews lastObject]];
            [self.frameViews addObject:grid];
        } else {
            BWLScoreGridView *grid = [self createFrameWithPrevView:[self.frameViews lastObject]];
            [self.frameViews addObject:grid];
        }
    }
    [self.frameViews keepWidthsEqual];
    [self.frameViews keepHeightsEqual];
}

- (BWLScoreGridResultView *)createLastFrameWithPrevView:(BWLScoreGridView *)prevView {
    BWLScoreGridResultView* grid = [[BWLScoreGridResultView alloc] init];
    [self.view addSubview: grid];
    [self addConstraintsForResultGridView:grid andPrevView:prevView];
    return grid;
}

- (BWLScoreGridView *)createFrameWithPrevView:(BWLScoreGridView *)prevView  {
    BWLScoreGridView *grid = [[BWLScoreGridView alloc]init] ;
    [self.view addSubview:grid];
    [self updateConstraintsBetweenPrevScoreGridView:prevView andScoreGridView:grid];
    return grid;
}

- (void)addContainerWithType:(ButtonType)buttonType {
    UIView *containerView = [self createContainerView];
    [self.view addSubview:containerView];
    [self updateConstraintsForContainerView:containerView];
    if (buttonType == BottomButtonType) {
        containerView.keepBottomInset.equal = KeepRequired(0);
        [self topOffsetBetweenContainerView:self.containerView andContainerViewForKeep:containerView];
    } else {
        containerView.keepTopOffsetTo(self.frameViews[0]).equal = KeepRequired(5);
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
        if (self.isGameEnd) {
            self.finishBlock();
        }
    };
    BWLButtonsComponent *buttonComponent = [[BWLTopButtonsComponent alloc] initWithContainerView:containerView titles:self.titlesForButtonsMapping[@(buttonType)] withBlock:buttonBlock];
    [buttonComponent addBWLButtons];
}

#pragma mark - Score counting
- (void)fillBowlingFrame:(UIButton *)button {
    NSInteger score = [button.titleLabel.text intValue];
    if (self.index < kLastGridIndex) {
        BWLScoreGridView *grid = self.frameViews[self.index];
        if (grid.score + score <= kSpare) {
            grid.score += score;
            [self fillScore:score toGridView:grid];
        } else return;
    } else {
        BWLScoreGridResultView *grid = self.frameViews[self.index];
        [self fillScore:score toGridResultView:grid];
    }
}

- (void)fillScore:(NSInteger)score toGridView:(BWLScoreGridView *)grid {
    BowlingFrameType type =  [self.playerCard updateGameScore:score  withIndex:self.index andBlock:^(NSInteger score, NSInteger index) {
        [self fillResult:score index:index];
    }];
    if (type == BowlingFrameStrike) {
        [grid setFirstAttemptScore:score];//
        self.index++;
    }
    if (type == BowlingFrameStandartFrame) {
        if ([grid isEmptyFirstAttempt]) {
            [grid setFirstAttemptScore:score];
        } else {
            [grid setSecondAttemptScore:score];
            self.index++;
        }
    }
}

- (void)fillScore:(NSInteger)score toGridResultView:(BWLScoreGridResultView *)grid {
    BowlingFrameType type =  [self.playerCard updateGameScore:score  withIndex:self.index andBlock:^(NSInteger score, NSInteger index) {
        [self fillResultForGridResult:score index:index];
    }];
    if (type == BowlingFrameStrike) {
        if ([grid isEmptyFirstAttempt]) {
            grid.score += score;
            [grid setFirstAttemptScore:score];
        } else if ([grid isEmptySecondAttempt]){
            [grid setSecondAttemptScore:score];//
        } else {
            [grid setThirdAttemptScore:score];
            [self hideContainers];
        }
    }
    if (type == BowlingFrameStandartFrame) {
        if ([grid isEmptyFirstAttempt]) {
            [grid setFirstAttemptScore:score];
            grid.score += score;
        } else if ([grid isEmptySecondAttempt]) {
            [grid setSecondAttemptScore:score];
            grid.score += score;
            if (grid.score < kSpare) {
                [self hideContainers];
            }
        } else {
            [grid setThirdAttemptScore:score];
            [self hideContainers];
        }
    }
}

- (void)fillResult:(NSInteger)score index:(NSInteger)index{
    BWLScoreGridView *grid = self.frameViews[index];
    self.playerCard.score += score;
    [grid setResultScore:self.playerCard.score];
}

- (void)fillResultForGridResult:(NSInteger)score index:(NSInteger)index{
    BWLScoreGridResultView *grid = self.frameViews[index];
    self.playerCard.score += score;
    [grid setResultScore:self.playerCard.score];
}

- (void)hideContainers {
    UIView *firstContainer = self.buttons[@(TopButtonType)];
    UIView *secondContainer = self.buttons[@(BottomButtonType)];
    firstContainer.hidden = YES;
    secondContainer.hidden = YES;
    [self finishGame];
    [self addResultLabel];
}

- (void)addResultLabel {
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.keepTopOffsetTo([self.frameViews firstObject]).equal = KeepRequired(0);
    label.text = [NSString stringWithFormat:@"%ld",(long)self.playerCard.score];
}

- (void)finishGame {
    self.isGameEnd = YES;
}

@end
