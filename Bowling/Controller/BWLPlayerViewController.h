//
//  BWLPlayerViewController.h
//  Bowling
//
//  Created by admin on 11/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWLScoreGridView.h"
#import "BWLScoreGridResultView.h"
#import "BWLScoreCard.h"
#import "KeepLayout.h"
@interface BWLPlayerViewController : UIViewController
@property (strong, nonatomic) UIView *containerView;
@property (nonatomic)BOOL isGameEnd;

- (id)initWithPlayer:(BWLScoreCard *)card andFinishBlock:(void (^)(void))finishBlock;
- (void)fillPlayerViewController;
@end
