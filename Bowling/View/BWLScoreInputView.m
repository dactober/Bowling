//
//  BWLScoreInputView.m
//  Bowling
//
//  Created by admin on 11/16/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLScoreInputView.h"
#import "BWLGameController.h"
#import "BWLStrikeFrame.h"
#import "BWLFrame.h"

@interface BWLScoreInputView()
@property (nonatomic, strong)UIButton *scoreInputButton;
@end

@implementation BWLScoreInputView

- (id)initWithTitle:(NSString *)title {
    self=[super init];
    if(self){
        self.scoreInputButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.scoreInputButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scoreInputButton addTarget:self  action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scoreInputButton setTitle:title forState:UIControlStateNormal];
        [self.scoreInputButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.scoreInputButton];
        [self addConstraintForButton:self.scoreInputButton];
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
    if (self.scoreInputAction != nil) {
        self.scoreInputAction(self.scoreInputButton);
    }
    if([sender.titleLabel.text isEqualToString:@"10"]){
        BWLStrikeFrame *strike = [BWLStrikeFrame new];
    } else {
        BWLFrame *frame = [BWLFrame new];
    }
    NSLog(@"%@",sender.titleLabel.text );
}

@end
