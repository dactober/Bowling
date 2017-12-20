//
//  ViewController.h
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "BWLWinnerOfGame.h"
@interface BWLGameController : UIViewController <UIScrollViewDelegate>
- (id)initWithScoreCards:(NSArray *)playersCards;
@property (nonatomic ,strong)id<MKAnnotation> annotation;
@property (nonatomic ,strong)BWLWinnerOfGame *winner;
@end

