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

@end
