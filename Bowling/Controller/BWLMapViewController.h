//
//  BWLMapViewController.h
//  Bowling
//
//  Created by admin on 12/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

static NSString * const kWinner = @"winner";
static NSString * const kLocation = @"location";
static NSString * const kEndGame = @"GameEndNotification";
@interface BWLMapViewController : UIViewController <MKMapViewDelegate>

@end
