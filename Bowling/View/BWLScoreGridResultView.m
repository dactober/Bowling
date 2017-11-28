//
//  BWLScoreGridResultView.m
//  Bowling
//
//  Created by admin on 11/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLScoreGridResultView.h"

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

@end
