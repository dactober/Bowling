//
//  BWLResultController.h
//  Bowling
//
//  Created by Aleksey Drachyov on 11/2/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BWLResultController : UITableViewController <UITableViewDelegate,UITableViewDataSource>
- (id)initWithScoreCards:(NSArray *)playersCards;
@end
