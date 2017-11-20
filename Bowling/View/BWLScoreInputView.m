//
//  BWLScoreInputView.m
//  Bowling
//
//  Created by admin on 11/16/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLScoreInputView.h"
#import "ViewController.h"

@implementation BWLScoreInputView

- (id)initWithTitle:(NSString *)title {
    self=[super init];
    if(self){
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [myButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [myButton addTarget:self  action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        [myButton setTitle:title forState:UIControlStateNormal];
        [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[myButton sizeToFit];
        [self addSubview:myButton];
        [self addConstraintForButton:myButton];
    }
    return self;
}

- (void)addConstraintForButton:(UIButton *)myButton {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:myButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:myButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:myButton
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:myButton
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0]];
}

- (void)pressButton:(UIButton *)sender {
    NSLog(@"%@",sender.titleLabel.text );
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
