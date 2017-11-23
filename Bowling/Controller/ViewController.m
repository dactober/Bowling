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
#import "BWLTopButtonsComponent.h"
#import "BWLBottomButonsComponent.h"
@interface ViewController ()
@property (strong,nonatomic) BWLScoreGridView *scoreGridView;
@property (strong,nonatomic) BWLScoreGridResultView *scoreGridResultView;
@property (strong,nonatomic) BWLTopButtonsComponent *topButtons;
@property (strong,nonatomic) BWLBottomButonsComponent *bottomButtons;
@property (strong,nonatomic) NSMutableArray *views;
@property (strong,nonatomic) NSMutableArray *buttons;
@property (strong,nonatomic) UIView *containerView;
@property (strong,nonatomic) UIView *containerViewForKeep;
@property (strong,nonatomic) NSArray *titles;
@property (strong,nonatomic) NSArray *titlesForKeepButtons;
@end

@implementation ViewController
const int height = 30;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    self.titlesForKeepButtons = @[@"6",@"7",@"8",@"9",@"10"];
    self.containerView = [self createContainerView];
    self.containerViewForKeep = [self createContainerView];
    self.topButtons = [[BWLTopButtonsComponent alloc] initWithContainerView:self.containerView andTitles:self.titles];
    self.bottomButtons = [[BWLBottomButonsComponent alloc] initWithContainerView:self.containerViewForKeep andTitles:self.titlesForKeepButtons];
    
    [self updateConstraintsForView:self.containerView];
    [self updateConstraintsForView:self.containerViewForKeep];
    [self topOffsetBetweenView:nil andSecondView:self.containerView];
    [self topOffsetBetweenView:self.containerView andSecondView:self.containerViewForKeep];
    
    [self.topButtons addBWLButtons];
    [self.bottomButtons addBWLButtons];
    
}

- (UIView *)createContainerView {
    UIView * view = [[UIView alloc]init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:view];
    return view;
}




- (void)updateConstraintsForView:(UIView *)view {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0
                                                                constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:height]];
}

- (void)topOffsetBetweenView:(UIView *)firstView andSecondView:(UIView *)secondView {
    if(firstView == nil) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:30]];
    } else {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:firstView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:30]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
