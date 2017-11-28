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
#import "BWLPlayerView.h"
#import "BWLScoreCard.h"
#import "KeepLayout.h"
@interface BWLPlayerViewController : NSObject
@property (nonatomic, strong)BWLPlayerView *playerView;
@property (strong, nonatomic) UIView *containerView;
- (id)initWithPlayer:(BWLScoreCard *)card;
- (void)addPlayer;
@end
