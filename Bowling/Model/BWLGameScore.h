//
//  BWLGameScore.h
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, FrameType) {
    Strike,
    Spare,
    Frame
    
};

@interface BWLGameScore : NSObject
@property (nonatomic) NSInteger score;
- (void)createFrame:(FrameType)frameType withScore:(NSInteger)score withNumberOfGrid:(NSInteger)numberOfGrid andBlock:(void(^)(NSInteger, NSInteger))block;
- (void)updateFrame;
@end
