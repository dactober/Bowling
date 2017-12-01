//
//  BWLScoreGridResultView.h
//  Bowling
//
//  Created by admin on 11/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWLScoreGridResultView : UIView

@property (weak, nonatomic) IBOutlet UILabel *result;
@property (nonatomic)NSInteger score;
- (BOOL)isEmptyFirstAttempt;
- (BOOL)isEmptySecondAttempt;
- (void)setFirstAttemptScore:(NSInteger)score;
- (void)setSecondAttemptScore:(NSInteger)score;
- (void)setThirdAttemptScore:(NSInteger)score;
- (void)setResultScore:(NSInteger)score;
@end
