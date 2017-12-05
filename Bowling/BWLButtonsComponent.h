//
//  BWLButtonsComponent.h
//  Bowling
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWLScoreInputView.h"
@interface BWLButtonsComponent : NSObject
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)NSMutableArray *buttons;
@property (nonatomic, strong)NSArray *titles;
- (id)initWithContainerView:(UIView *)containerView titles:(NSArray *)titles withBlock:(void (^)(UIButton *))callbackBlock;
- (void)addBWLButtons;
- (BWLScoreInputView *)createScoreInputViewWithTitle:(NSString *)title isLastItem:(BOOL)isLastItem;
- (void)addConstraintBetweenViews:(BWLScoreInputView *)firstView andView:(BWLScoreInputView *)secondView isLastItem:(BOOL)isLastItem;
@end
