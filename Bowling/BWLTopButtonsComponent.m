//
//  BWLCreateButton.m
//  Bowling
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLTopButtonsComponent.h"
@interface BWLTopButtonsComponent()
@end


@implementation BWLTopButtonsComponent

static const int heightButtons = 30;
static const int topOffset = 0;
static const int leadingOffset = 5;
static const int trailingOffset = 0;

- (void)addConstraintBetweenViews:(BWLScoreInputView *)firstView andView:(BWLScoreInputView *)secondView isLastItem:(BOOL)isLastItem {
    if(secondView == nil) {
        [self topOffsetToSuperView:firstView];
        [self leadingOffsetBetween:firstView andSecondView:nil];
        [self equalHeightBetweeen:firstView andSecondView:nil];
    } else {
        if(isLastItem) {
            [self trailingOffsetToSuperview:firstView];
        }
        [self topOffsetToSuperView:firstView];
        [self leadingOffsetBetween:firstView andSecondView:secondView];
        [self equalWidthBetweeen:firstView andSecondView:secondView];
        [self equalHeightBetweeen:firstView andSecondView:secondView];
    }
}

- (void) topOffsetToSuperView:(BWLScoreInputView *)view {
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:topOffset]];
}

- (void) equalHeightBetweeen:(BWLScoreInputView *)firstView andSecondView:(BWLScoreInputView *)secondView{
    if(secondView == nil) {
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:heightButtons]];
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

- (void) equalWidthBetweeen:(BWLScoreInputView *)firstView andSecondView:(BWLScoreInputView *)secondView{
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:secondView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0]];
}

- (void) leadingOffsetBetween:(BWLScoreInputView *) firstView andSecondView:(BWLScoreInputView *)secondView {
    if(secondView == nil){
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.containerView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0
                                                                        constant:leadingOffset]];
    } else {
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:firstView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:secondView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:leadingOffset]];
    }
    
}

- (void) trailingOffsetToSuperview:(BWLScoreInputView *)view {
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:trailingOffset]];
}



@end
