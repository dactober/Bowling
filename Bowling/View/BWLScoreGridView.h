//
//  BWLScoreGridView.h
//  Bowling
//
//  Created by admin on 11/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWLScoreGridView : UIView

@property (nonatomic) NSInteger score;
- (BOOL)isEmptyFirstAttempt;
- (void)setFirstAttemptScore:(NSInteger)score;
- (void)setSecondAttemptScore:(NSInteger)score;
- (void)setResultScore:(NSInteger)score;
@end
