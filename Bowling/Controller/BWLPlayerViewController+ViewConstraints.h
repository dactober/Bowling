//
//  BWLPlayerViewController+ViewConstraints.h
//  Bowling
//
//  Created by admin on 11/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLPlayerViewController.h"

@interface BWLPlayerViewController (ViewConstraints)
- (void)addConstraintsForResultGridView:(BWLScoreGridResultView *)grid andPrevView:(BWLScoreGridView *)prevGrid;
- (void)updateConstraintsBetweenPrevScoreGridView:(BWLScoreGridView *)prevView andScoreGridView:(BWLScoreGridView *)view;
- (void)updateConstraintsForContainerView:(UIView *)view;
- (void)topOffsetBetweenContainerView:(UIView *)firstView andContainerViewForKeep:(UIView *)secondView;
@end
