//
//  BWLFrameView.m
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "BWLFrameView.h"
IB_DESIGNABLE

@implementation BWLFrameView

- (void)drawRect:(CGRect)rect {
    CGRect myFrame= self.bounds;
    CGRectInset(myFrame, 5, 5);
    [_fillColor set];
    UIRectFrame(myFrame);
}


@end
