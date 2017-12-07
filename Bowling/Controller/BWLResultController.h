//
//  BWLResultController.h
//  Bowling
//
//  Created by Aleksey Drachyov on 11/2/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "BWLWinnerOfGame.h"
@interface BWLResultController : UITableViewController <UITableViewDelegate,UITableViewDataSource>
- (id)initWithScoreCards:(NSArray *)playersCards winner:(BWLWinnerOfGame *)winner andAnnotation:(id<MKAnnotation>)annotation;

@end
