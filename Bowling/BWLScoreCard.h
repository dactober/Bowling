//
//  BWLScoreCard.h
//  Bowling
//
//  Created by Aleksey Drachyov on 11/2/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWLScoreCard : NSObject
@property (nonatomic,copy)NSString* playerName;
@property(nonatomic)NSInteger score;
+ (NSString*)title;
- (void)setPlayerName:(NSString *)name;
- (void)addScore:(NSInteger)score;
- (void)printScore;
- (id)initWithName:(NSString*)name;
@end