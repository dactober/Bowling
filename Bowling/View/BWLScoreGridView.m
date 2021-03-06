//
//  BWLScoreGridView.m
//  Bowling
//
//  Created by admin on 11/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLScoreGridView.h"

@interface BWLScoreGridView ()
@property (strong, nonatomic) IBOutlet UIView *scoreGridView;
@property (weak, nonatomic) IBOutlet UILabel *firstAttemp;
@property (weak, nonatomic) IBOutlet UILabel *secondAttemp;
@property (weak, nonatomic) IBOutlet UILabel *result;
@end

@implementation BWLScoreGridView
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}
- (instancetype)init {
    self=[super init];
    if(self){
        [self customInit];
    }
    return self;
}

- (void)customInit {
        [[NSBundle mainBundle] loadNibNamed:@"BWLScoreGridViewXIB" owner:self options:nil];
        [self addSubview:self.scoreGridView];
        self.scoreGridView.frame=self.bounds;
}

- (BOOL)isEmptyFirstAttempt {
    if ([self.firstAttemp.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setFirstAttemptScore:(NSInteger)score {
    self.firstAttemp.text = [self stringWithInteger:score];
}

- (void)setSecondAttemptScore:(NSInteger)score {
    self.secondAttemp.text = [self stringWithInteger:score];
}

- (void)setResultScore:(NSInteger)score {
    self.result.text = [self stringWithInteger:score];
}

- (NSString *)stringWithInteger:(NSInteger)number {
    return [NSString stringWithFormat:@"%ld",(long)number];
}

@end
