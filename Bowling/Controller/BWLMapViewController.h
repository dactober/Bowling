//
//  BWLMapViewController.h
//  Bowling
//
//  Created by admin on 12/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
typedef void(^addressCompletionBlock)(NSString *);
@interface BWLMapViewController : UIViewController <MKMapViewDelegate>
@end
