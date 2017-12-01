//
//  BWLScoreGridResultView.m
//  Bowling
//
//  Created by admin on 11/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLScoreGridResultView.h"

@interface BWLScoreGridResultView()
@property (strong, nonatomic) IBOutlet UIView *scoreGridView;
@property (weak, nonatomic) IBOutlet UILabel *firstAttemp;
@property (weak, nonatomic) IBOutlet UILabel *secondAttemp;
@property (weak, nonatomic) IBOutlet UILabel *thirdAttemp;
@end

@implementation BWLScoreGridResultView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self customInit];
    }
    return self;
}

- (void)customInit {
    
    [[NSBundle mainBundle] loadNibNamed:@"BWLScoreGridResultView" owner:self options:nil];
    [self addSubview:self.scoreGridView];
    self.scoreGridView.frame=self.bounds;
}

- (void)setFirstAttemptScore:(NSInteger)score {
        self.firstAttemp.text = [self stringWithInteger:score];
}

- (void)setSecondAttemptScore:(NSInteger)score {
    self.secondAttemp.text = [self stringWithInteger:score];
}

- (void)setThirdAttemptScore:(NSInteger)score {
    self.thirdAttemp.text = [self stringWithInteger:score];
}

- (void)setResultScore:(NSInteger)score {
    self.result.text = [self stringWithInteger:score];
}

- (BOOL)isEmptyFirstAttempt {
    if ([self.firstAttemp.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEmptySecondAttempt {
    if ([self.secondAttemp.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)stringWithInteger:(NSInteger)number {
    return [NSString stringWithFormat:@"%ld",(long)number];
}


@end
