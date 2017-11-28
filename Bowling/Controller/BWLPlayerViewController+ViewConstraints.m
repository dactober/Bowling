//
//  BWLPlayerViewController+ViewConstraints.m
//  Bowling
//
//  Created by admin on 11/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLPlayerViewController+ViewConstraints.h"
@implementation BWLPlayerViewController (ViewConstraints)

const static int kScoreGridHeight = 30;
const static int kLeadingOffsetToSuperView = 10;
const static int kLeadingOffsetToView = 0;
const static int kTrailingOffsetToSuperView = 10;
const static int kTopOffsetToSuperView = 0;

- (void)addConstraintsForResultGridView:(BWLScoreGridResultView *)grid andPrevView:(BWLScoreGridView *)prevGrid {
    grid.keepTopInset.equal = KeepRequired(kTopOffsetToSuperView);
    grid.keepRightInset.equal = KeepRequired(kTrailingOffsetToSuperView);
    grid.keepLeftOffsetTo(prevGrid).equal = KeepRequired(kLeadingOffsetToView);
}

- (void)updateConstraintsBetweenPrevScoreGridView:(BWLScoreGridView *)prevView andScoreGridView:(BWLScoreGridView *)view {
    if (prevView == nil) {
        view.keepLeftInset.equal = KeepRequired(kLeadingOffsetToSuperView);
        view.keepTopInset.equal = KeepRequired(kTopOffsetToSuperView);
        view.keepHeight.equal = KeepRequired(kScoreGridHeight);
    } else {
        view.keepTopInset.equal = KeepRequired(kTopOffsetToSuperView);
        view.keepLeftOffsetTo(prevView).equal = KeepRequired(kLeadingOffsetToView);
    }
}

- (void)updateConstraintsForContainerView:(UIView *)view {
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
                                                                 constant:kScoreGridHeight]];
}

- (void)topOffsetBetweenContainerView:(UIView *)firstView andContainerViewForKeep:(UIView *)secondView {
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
