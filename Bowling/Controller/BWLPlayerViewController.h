//
//  BWLPlayerViewController.h
//  Bowling
//
//  Created by admin on 11/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWLPlayerView.h"
#import "BWLScoreCard.h"
@interface BWLPlayerViewController : NSObject
@property (nonatomic, strong)BWLPlayerView *playerView;
- (id)initWithPlayer:(BWLScoreCard *)card;
- (void)createGameForPlayer;
@end
