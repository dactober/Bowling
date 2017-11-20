//
//  ViewController.m
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "ViewController.h"
#import "BWLScoreGridView.h"
#import "BWLScoreGridResultView.h"
#import "KeepLayout.h"
#import "BWLScoreInputView.h"
@interface ViewController ()
@property (strong, nonatomic)  BWLScoreGridView *scoreGridView;
@property(strong,nonatomic) BWLScoreGridResultView *scoreGridResultView;
@property (strong,nonatomic) NSMutableArray *views;
@property (strong,nonatomic) NSMutableArray *buttons;
@property (strong,nonatomic) UIView *containerView;
@end

@implementation ViewController

const int height = 50;
const int heightButtons = 30;
const int count = 10;
const int xOffset = 30;
const int countButtons = 6;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView = [[UIView alloc]init];
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.containerView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.containerView];
    [self addButton];
    //[self addBowlingFrames];
}
-(BWLScoreInputView *)createButtom:(NSString *)title isLastItem:(BOOL)flag{
    BWLScoreInputView *myButton = [[BWLScoreInputView alloc] initWithTitle:title];
    BWLScoreInputView *prevButton = [self.buttons lastObject];
    [myButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.containerView addSubview:myButton];
    [self addConstraintBetweenViews:myButton andView:prevButton isLastItem:flag];
    return myButton;
}

-(void)addButton {
    self.buttons = [NSMutableArray new];
    //[self.buttons addObject:[self createButtom:@"0" isLastItem:NO]];
    int x = 0;
    for(int i = 0;i < countButtons;i++) {
        if(i < countButtons - 1) {
        [self.buttons addObject:[self createButtom:[NSString stringWithFormat:@"%d",i] isLastItem:NO]];
        } else {
        [self.buttons addObject:[self createButtom:[NSString stringWithFormat:@"%d",i] isLastItem:YES]];
        }
        x+=xOffset;
    }
}

-(void)addConstraintBetweenViews:(BWLScoreInputView *)firstView andView:(BWLScoreInputView *)secondView isLastItem:(BOOL)flag {
    if(secondView == nil) {
        [self topOffsetToSuperView:firstView];
        [self leadingOffsetBetween:firstView andSecondView:nil];
        [self equalHeightBetweeen:firstView andSecondView:nil];
    } else {
        if(flag) {
            [self trailingOffsetToSuperview:firstView];
        }
        [self topOffsetToSuperView:firstView];
        [self leadingOffsetBetween:firstView andSecondView:secondView];
        [self equalWidthBetweeen:firstView andSecondView:secondView];
        [self equalHeightBetweeen:firstView andSecondView:secondView];
    }
}

-(void) topOffsetToSuperView:(BWLScoreInputView *)view {
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:0]];
}

-(void) equalHeightBetweeen:(BWLScoreInputView *)firstView andSecondView:(BWLScoreInputView *)secondView{
    if(secondView == nil) {
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:30]];
    } else {
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:secondView
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:0]];
    }
    
}

-(void) equalWidthBetweeen:(BWLScoreInputView *)firstView andSecondView:(BWLScoreInputView *)secondView{
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:secondView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0]];
}

-(void) leadingOffsetBetween:(BWLScoreInputView *) firstView andSecondView:(BWLScoreInputView *)secondView {
    if(secondView == nil){
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.containerView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0
                                                                        constant:5]];
    } else {
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:secondView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:5]];
    }
    
}

-(void) trailingOffsetToSuperview:(BWLScoreInputView *)view {
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:0]];
}



- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:heightButtons]];
}

- (BWLScoreGridView *)createFirstFrame {
    BWLScoreGridView* grid = [[BWLScoreGridView alloc] initWithFrame:CGRectMake(0, 0, 0,  0)];
    [self.view addSubview:grid];
    grid.keepLeftInset.equal = KeepRequired(0);
    grid.keepTopInset.equal = KeepRequired(0);
    grid.keepHeight.equal = KeepRequired(height);
    return grid;
}

- (BWLScoreGridResultView *)createLastFrame {
    BWLScoreGridResultView* grid = [[BWLScoreGridResultView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    BWLScoreGridView *prevGrid = [self.views lastObject];
    [self.view addSubview: grid];
    grid.keepTopInset.equal = KeepRequired(0);
    grid.keepRightInset.equal = KeepRequired(0);
    grid.keepLeftOffsetTo(prevGrid).equal = KeepRequired(0);
    return grid;
}

- (BWLScoreGridView *)createFrame {
    BWLScoreGridView *grid = [[BWLScoreGridView alloc]initWithFrame:CGRectMake(0, 0, 0,  0)] ;
    BWLScoreGridView *prevGrid = [self.views lastObject];
    [self.view addSubview:grid];
    grid.keepTopInset.equal = KeepRequired(0);
    grid.keepLeftOffsetTo(prevGrid).equal = KeepRequired(0);
    return grid;
}

- (void)addBowlingFrames {
    self.views = [NSMutableArray new];
    [self.views addObject:[self createFirstFrame]];
    
    for (int i = 1; i < count; i++) {
        if(i < count - 1) {
            [self.views addObject:[self createFrame]];

       } else {
           [self.views addObject:[self createLastFrame]];
       }
    }
    [self.views keepWidthsEqual];
    [self.views keepHeightsEqual];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
