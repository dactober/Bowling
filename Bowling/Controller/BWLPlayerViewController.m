//
//  BWLPlayerViewController.m
//  Bowling
//
//  Created by admin on 11/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLPlayerViewController.h"
#import "BWLScoreGridView.h"
#import "BWLScoreGridResultView.h"
#import "KeepLayout.h"
#import "BWLScoreInputView.h"
#import "BWLTopButtonsComponent.h"
#import "BWLBottomButonsComponent.h"

typedef void (^ButtonBlock)(UIButton *);
@interface BWLPlayerViewController ()
@property (nonatomic, copy) ButtonBlock buttonBlock;
@property (strong, nonatomic) BWLScoreGridView *scoreGridView;
@property (strong, nonatomic) BWLScoreGridResultView *scoreGridResultView;
@property (strong, nonatomic) BWLTopButtonsComponent *topButtons;
@property (strong, nonatomic) BWLBottomButonsComponent *bottomButtons;
@property (strong, nonatomic)BWLScoreCard *playerCard;
@property (strong, nonatomic) NSMutableArray *views;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *containerViewForKeep;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *titlesForKeepButtons;
@property (nonatomic)NSInteger numberOfGrid;
@end

@implementation BWLPlayerViewController

const static int kHeight = 30;
const static int kLeadingOffset = 10;
const static int kLeadingOffsetToView = 0;
const static int kTrailingOffset = 10;
const static int kTopOffset = 0;
const static int kBottomOffset = 5;

- (id)initWithPlayer:(BWLScoreCard *)card {
    self = [super init];
    if (self) {
        self.playerCard = card;
        
        self.playerView = [[BWLPlayerView alloc]init];
        [self.playerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.numberOfGrid = 0;
        self.views = [NSMutableArray new];
        
    }
    return self;
}

- (UIView *)createContainerView {
    UIView * view = [[UIView alloc]init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setBackgroundColor:[UIColor grayColor]];
    [self.playerView addSubview:view];
    return view;
}

- (void)createGameForPlayer {
    self.titles = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    self.titlesForKeepButtons = @[@"6",@"7",@"8",@"9",@"10"];
    self.containerView = [self createContainerView];
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.containerViewForKeep = [self createContainerView];
    [self.containerViewForKeep setTranslatesAutoresizingMaskIntoConstraints:NO];
    __weak typeof(self) _self_weak = self;
    self.buttonBlock = ^(UIButton *button) {
        [_self_weak fillFrame:button _self_weak:_self_weak];
    };
    self.topButtons = [[BWLTopButtonsComponent alloc] initWithContainerView:self.containerView Titles:self.titles withBlock:self.buttonBlock];
    self.bottomButtons = [[BWLBottomButonsComponent alloc] initWithContainerView:self.containerViewForKeep Titles:self.titlesForKeepButtons withBlock:self.buttonBlock];
    [self updateConstraintsForView:self.containerView];
    [self updateConstraintsForView:self.containerViewForKeep];
    self.containerViewForKeep.keepBottomInset.equal = KeepRequired(0);
    [self topOffsetBetweenView:self.containerView andSecondView:self.containerViewForKeep];
    [self.topButtons addBWLButtons];
    [self.bottomButtons addBWLButtons];
    [self addBowlingFrames];
    self.containerView.keepTopOffsetTo(self.views[0]).equal = KeepRequired(5);
}

- (void)fillFrame:(UIButton *)button _self_weak:(BWLPlayerViewController *)_self_weak{
    NSInteger i = [button.titleLabel.text intValue];
    BWLScoreGridView *grid = _self_weak.views[_self_weak.numberOfGrid];
    _self_weak.playerCard.score += i;
    if (i < 10) {
        if ([grid.firstAttempt.text isEqualToString:@""]) {
            grid.firstAttempt.text = button.titleLabel.text ;
        } else {
            grid.secondAttemp.text = button.titleLabel.text;
            grid.result.text = [NSString stringWithFormat:@"%ld",(long)_self_weak.playerCard.score];
            _self_weak.numberOfGrid++;
        }
    } else {
        grid.firstAttempt.text = button.titleLabel.text;
        grid.result.text = [NSString stringWithFormat:@"%ld",(long)_self_weak.playerCard.score];
        _self_weak.numberOfGrid++;
    }
}

- (BWLScoreGridResultView *)createLastFrame {
    BWLScoreGridResultView* grid = [[BWLScoreGridResultView alloc] init];
    BWLScoreGridView *prevGrid = [self.views lastObject];
    [self.playerView addSubview: grid];
    [self addConstraintsForResultGridView:grid andPrevView:prevGrid];
    return grid;
}

- (void)addConstraintsForResultGridView:(BWLScoreGridResultView *)grid andPrevView:(BWLScoreGridView *)prevGrid {
    grid.keepTopInset.equal = KeepRequired(kTopOffset);
    grid.keepBottomOffsetTo(self.containerView).equal = KeepRequired(kBottomOffset);
    grid.keepRightInset.equal = KeepRequired(kTrailingOffset);
    grid.keepLeftOffsetTo(prevGrid).equal = KeepRequired(kLeadingOffsetToView);
}

- (BWLScoreGridView *)createFrame {
    BWLScoreGridView *grid = [[BWLScoreGridView alloc]init] ;
    BWLScoreGridView *prevGrid = [self.views lastObject];
    [self.playerView addSubview:grid];
    [self updateConstraintsBetweenKeepView:prevGrid andSecondView:grid];
    return grid;
}

- (void)addBowlingFrames {
    for (int i = 0; i < 10; i++) {
        if(i < 9) {
            BWLScoreGridView *grid = [self createFrame];
            [self.views addObject:grid];
            
        } else {
            BWLScoreGridResultView *grid = [self createLastFrame];
            [self.views addObject:grid];
        }
    }
    [self.views keepWidthsEqual];
    [self.views keepHeightsEqual];
}

- (void)updateConstraintsBetweenKeepView:(BWLScoreGridView *)firstView andSecondView:(BWLScoreGridView *)secondView{
    if (firstView == nil) {
        secondView.keepLeftInset.equal = KeepRequired(kLeadingOffset);
        secondView.keepTopInset.equal = KeepRequired(kTopOffset);
        secondView.keepHeight.equal = KeepRequired(kHeight);
    } else {
        secondView.keepTopInset.equal = KeepRequired(kTopOffset);
        secondView.keepLeftOffsetTo(firstView).equal = KeepRequired(kLeadingOffsetToView);
    }
}

- (void)updateConstraintsForView:(UIView *)view {
    [self.playerView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.playerView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:10]];
    [self.playerView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.playerView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-10]];
    [self.playerView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:kHeight]];
}

- (void)topOffsetBetweenView:(UIView *)firstView andSecondView:(UIView *)secondView {
    if(firstView == nil) {
                [self.playerView addConstraint:[NSLayoutConstraint constraintWithItem:secondView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.playerView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0]];
    } else {
        [self.playerView addConstraint:[NSLayoutConstraint constraintWithItem:secondView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:firstView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:5]];
    }
}

@end
