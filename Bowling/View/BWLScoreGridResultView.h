//
//  BWLScoreGridResultView.h
//  Bowling
//
//  Created by admin on 11/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWLScoreGridResultView : UIView
@property (strong, nonatomic) IBOutlet UIView *scoreGridView;
@property (weak, nonatomic) IBOutlet UILabel *firstAttemp;
@property (weak, nonatomic) IBOutlet UILabel *secondAttemp;
@property (weak, nonatomic) IBOutlet UILabel *thirdAttemp;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (nonatomic)NSInteger score;
- (BOOL)isEmptyFirstAttemp;
- (BOOL)isEmptySecondAttemp;
- (void)setFirstAttempScore:(NSInteger)score;
- (void)setSecondAttempScore:(NSInteger)score;
- (void)setThirdAttempScore:(NSInteger)score;
- (void)setResultScore:(NSInteger)score;
@end
