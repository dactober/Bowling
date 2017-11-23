//
//  BWLButtonsComponent.m
//  Bowling
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLButtonsComponent.h"
@interface BWLButtonsComponent()

@end

@implementation BWLButtonsComponent

- (id)initWithContainerView:(UIView *)containerView andTitles:(NSArray *)titles {
    self = [super init];
    if(self) {
        self.containerView = containerView;
        self.buttons = [NSMutableArray new];
        self.titles = titles;
        
    }
    return self;
}

- (void)addBWLButtons {
    self.buttons = [NSMutableArray new];
    for(int i = 0;i < self.titles.count;i++) {
        if(i < self.titles.count - 1) {
            [self createScoreInputViewWithTitle:self.titles[i] isLastItem:NO];
        } else {
            [self createScoreInputViewWithTitle:self.titles[i] isLastItem:YES];
        }
    }
}

- (BWLScoreInputView *)createScoreInputViewWithTitle:(NSString *)title isLastItem:(BOOL)isLastItem {
    BWLScoreInputView *myButton = [[BWLScoreInputView alloc] initWithTitle:title];
    BWLScoreInputView *prevButton = [self.buttons lastObject];
    [myButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.containerView addSubview:myButton];
    [self.buttons addObject:myButton];
    [self addConstraintBetweenViews:myButton andView:prevButton isLastItem:isLastItem];
    return myButton;
}
 
- (void)addConstraintBetweenViews:(BWLScoreInputView *)firstView andView:(BWLScoreInputView *)secondView isLastItem:(BOOL)isLastItem {
    
}

@end
