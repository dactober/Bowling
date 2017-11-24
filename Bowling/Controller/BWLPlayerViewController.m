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
@property (strong, nonatomic)UILabel *nameOfPlayer;
@end

@implementation BWLPlayerViewController

const static int height = 30;
const static int leadingOffset = 10;
const static int leadingOffsetToView = 0;
const static int trailingOffset = 10;
const static int topOffset = 0;
const static int bottomOffset = 5;

static int numberOfGrid = 0;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithPlayer:(BWLScoreCard *)card {
    self = [super init];
    if (self) {
        self.playerView = [[BWLPlayerView alloc]init];
        self.playerCard = card;
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
    
    BWLScoreCard *card = self.playerCard;
    self.titles = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    self.titlesForKeepButtons = @[@"6",@"7",@"8",@"9",@"10"];
    self.containerView = [self createContainerView];
    self.containerViewForKeep = [self createContainerView];
    
    __weak typeof(self) _self_weak = self;
    self.buttonBlock = ^(UIButton *button) {
        NSInteger i = [button.titleLabel.text intValue];
        BWLScoreGridView *grid = _self_weak.views[numberOfGrid];
        _self_weak.playerCard.score += i;
        if (i < 10) {
            if ([grid.firstAttempt.text isEqualToString:@""]) {
                grid.firstAttempt.text = button.titleLabel.text ;
            } else {
                grid.secondAttemp.text = button.titleLabel.text;
                grid.result.text = [NSString stringWithFormat:@"%ld",(long)_self_weak.playerCard.score];
                numberOfGrid++;
            }
            
        } else {
            grid.firstAttempt.text = button.titleLabel.text;
            grid.result.text = [NSString stringWithFormat:@"%ld",(long)_self_weak.playerCard.score];
            numberOfGrid++;
        }
        // NSLog(@"aaa");
    };
    
    self.topButtons = [[BWLTopButtonsComponent alloc] initWithContainerView:self.containerView Titles:self.titles withBlock:self.buttonBlock];
    self.bottomButtons = [[BWLBottomButonsComponent alloc] initWithContainerView:self.containerViewForKeep Titles:self.titlesForKeepButtons withBlock:self.buttonBlock];
    
    [self updateConstraintsForView:self.containerView];
    [self updateConstraintsForView:self.containerViewForKeep];
    self.containerViewForKeep.keepBottomInset.equal = KeepRequired(0);
    //[self topOffsetBetweenView:nil andSecondView:self.containerView];
    [self topOffsetBetweenView:self.containerView andSecondView:self.containerViewForKeep];
    
    [self.topButtons addBWLButtons];
    [self.bottomButtons addBWLButtons];
    
    
    self.nameOfPlayer = [UILabel new];
    [self.nameOfPlayer  setFont:[UIFont systemFontOfSize:15]];
    [self.playerView addSubview:self.nameOfPlayer];
    self.nameOfPlayer.keepTopInset.equal = KeepRequired(0);
    self.nameOfPlayer.keepLeftInset.equal = KeepRequired(leadingOffset);
    self.nameOfPlayer.text = card.playerName;
    
    self.views = [NSMutableArray new];
    [self.views addObject:([self createFirstFrame])];
    
    [self addBowlingFrames];
    
    self.containerView.keepTopOffsetTo(self.views[0]).equal = KeepRequired(5);
    
    
}


- (BWLScoreGridView *)createFirstFrame {
    BWLScoreGridView* grid = [[BWLScoreGridView alloc] init];
    [self.playerView addSubview:grid];
    grid.keepLeftInset.equal = KeepRequired(leadingOffset);
    grid.keepBottomOffsetTo(self.containerView).equal = KeepRequired(bottomOffset);
    grid.keepTopInset.equal = KeepRequired(topOffset);
    grid.keepHeight.equal = KeepRequired(height);
    return grid;
}
- (BWLScoreGridResultView *)createLastFrame {
    BWLScoreGridResultView* grid = [[BWLScoreGridResultView alloc] init];
    BWLScoreGridView *prevGrid = [self.views lastObject];
    [self.playerView addSubview: grid];
    grid.keepTopInset.equal = KeepRequired(topOffset);
    grid.keepBottomOffsetTo(self.containerView).equal = KeepRequired(bottomOffset);
    grid.keepRightInset.equal = KeepRequired(trailingOffset);
    grid.keepLeftOffsetTo(prevGrid).equal = KeepRequired(leadingOffsetToView);
    return grid;
}
- (BWLScoreGridView *)createFrame {
    BWLScoreGridView *grid = [[BWLScoreGridView alloc]init] ;
    BWLScoreGridView *prevGrid = [self.views lastObject];
    [self.playerView addSubview:grid];
    grid.keepBottomOffsetTo(self.containerView).equal = KeepRequired(bottomOffset);
    grid.keepTopInset.equal = KeepRequired(topOffset);
    grid.keepLeftOffsetTo(prevGrid).equal = KeepRequired(leadingOffsetToView);
    return grid;
}
- (void)addBowlingFrames {
    for (int i = 1; i < 10; i++) {
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
                                                           constant:height]];
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
