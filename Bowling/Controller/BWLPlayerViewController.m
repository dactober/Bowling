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
@interface BWLPlayerViewController ()
@property (nonatomic, copy) ButtonBlock buttonBlock;
@property (strong, nonatomic) BWLScoreGridView *scoreGridView;
@property (strong, nonatomic) BWLScoreGridResultView *scoreGridResultView;
@property (strong, nonatomic) BWLButtonsComponent *topButton;
@property (strong, nonatomic) BWLButtonsComponent *bottomButton;
@property (strong, nonatomic) BWLScoreCard *playerCard;
@property (strong, nonatomic) NSMutableArray *views;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIView *containerViewForKeep;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *titlesForKeepButtons;
@property (nonatomic) NSInteger numberOfGrid;
@property (strong, nonatomic) NSDictionary *titlesForButtonsMapping;
@end

@implementation BWLPlayerViewController

const static int kGridCount = 10;
const static int kLastGridIndex = kGridCount - 1;
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
    self.numberOfGrid = 0;
    self.views = [NSMutableArray new];
}

- (NSDictionary *)titlesForButtonsMapping {
    if (!_titlesForButtonsMapping) {
        _titlesForButtonsMapping = @{@(TopButtonType)  : @[@"0",@"1",@"2",@"3",@"4",@"5"],
                            @(BottomButtonType) : @[@"6",@"7",@"8",@"9",@"10"]};
    }
    return _titlesForButtonsMapping;
}

- (void)addPlayer {
    __weak typeof(self) _self_weak = self;
    self.buttonBlock = ^(UIButton *button) {
        [_self_weak fillFrame:button];
    };
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
}

- (UIView *)createContainerView {
    UIView * view = [[UIView alloc]init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setBackgroundColor:[UIColor grayColor]];
    return view;
}

- (void)addButtonsWithType:(ButtonType)buttonType andContainerView:(UIView *)containerView {
    BWLButtonsComponent *buttonComponent = [[BWLTopButtonsComponent alloc] initWithContainerView:containerView titles:self.titlesForButtonsMapping[@(buttonType)] withBlock:self.buttonBlock];
    [buttonComponent addBWLButtons];
}

- (void)fillFrame:(UIButton *)button {
    NSInteger i = [button.titleLabel.text intValue];
    BWLScoreGridView *grid = self.views[self.numberOfGrid];
    self.playerCard.score += i;
    if (i < kGridCount) {
        if ([grid.firstAttempt.text isEqualToString:@""]) {
            grid.firstAttempt.text = button.titleLabel.text ;
        } else {
            grid.secondAttemp.text = button.titleLabel.text;
            grid.result.text = [NSString stringWithFormat:@"%ld",(long)self.playerCard.score];
            self.numberOfGrid++;
        }
    } else {
        grid.firstAttempt.text = button.titleLabel.text;
        grid.result.text = [NSString stringWithFormat:@"%ld",(long)self.playerCard.score];
        self.numberOfGrid++;
    }
}

@end
