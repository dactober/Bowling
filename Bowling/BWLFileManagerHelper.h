//
//  FileManagerHelper.h
//  Bowling
//
//  Created by admin on 12/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWLWinnerOfGame.h"

@interface BWLFileManagerHelper : NSObject
- (BOOL)addWinner:(BWLWinnerOfGame *)winner;
@property (nonatomic, strong, readonly) NSArray<BWLWinnerOfGame *> *winners;
@end
