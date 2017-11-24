//
//  BWLScoreInputView.h
//  Bowling
//
//  Created by admin on 11/16/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ScoreInputActionBlock)(UIButton *);

@interface BWLScoreInputView : UIView

- (id)initWithTitle:(NSString *)title;
@property (nonatomic, copy) ScoreInputActionBlock scoreInputAction;

@end
