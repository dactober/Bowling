//
//  BWLFrameView.h
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWLFrameView : UIView
@property(nonatomic) IBInspectable NSInteger lineWidht;
@property(nonatomic) IBInspectable UIColor* fillColor;
@property(nonatomic,weak)IBOutlet UIView* frameView;
@end
