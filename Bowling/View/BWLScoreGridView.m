//
//  BWLScoreGridView.m
//  Bowling
//
//  Created by admin on 11/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLScoreGridView.h"


@implementation BWLScoreGridView

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
   
        [[NSBundle mainBundle] loadNibNamed:@"BWLScoreGridViewXIB" owner:self options:nil];
        [self addSubview:self.scoreGridView];
        self.scoreGridView.frame=self.bounds;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
