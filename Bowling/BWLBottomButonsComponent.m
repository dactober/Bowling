//
//  BWLCreateButtonWithKeepLayout.m
//  Bowling
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLBottomButonsComponent.h"
#import "KeepLayout.h"
#import "BWLScoreInputView.h"
@interface BWLBottomButonsComponent()
@end

@implementation BWLBottomButonsComponent
static const int heightButton = 30;
static const int leadingOffset = 40;
static const int topOffset = 0;
static const int trailingOffset = 40;
static const int leftOfssetToView = 10;

- (void)addConstraintBetweenView:(BWLScoreInputView *)firstView andView:(BWLScoreInputView *)secondView isLastItem:(BOOL)isLastItem {
    if(secondView == nil) {
        firstView.keepLeftInset.equal = KeepRequired(leadingOffset);
        firstView.keepTopInset.equal = KeepRequired(topOffset);
        firstView.keepHeight.equal = KeepRequired(heightButton);
    } else {
        if(isLastItem) {
            firstView.keepRightInset.equal = KeepRequired(trailingOffset);
            [self.buttons keepWidthsEqual];
            [self.buttons keepHeightsEqual];
        }
        firstView.keepTopInset.equal = KeepRequired(topOffset);
        firstView.keepLeftOffsetTo(secondView).equal = KeepRequired(leftOfssetToView);
    }
}



@end
