//
//  BWLCommonFrame.h
//  Bowling
//
//  Created by admin on 11/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, BowlingFrameType) {
    Strike,
    Spare,
    Frame
    
};
@interface BWLCommonFrame : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger attemp;
@property (nonatomic, readonly) NSInteger index;
@property (nonatomic, readonly) BowlingFrameType type;

- (void)addScore:(NSInteger)score;

- (instancetype)initWithScore:(NSInteger)score index:(NSInteger)index;

@end
