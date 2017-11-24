//
//  BWLScoreGridView.h
//  Bowling
//
//  Created by admin on 11/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWLScoreGridView : UIView
@property (strong, nonatomic) IBOutlet UIView *scoreGridView;
@property (weak, nonatomic) IBOutlet UILabel *firstAttempt;
@property (weak, nonatomic) IBOutlet UILabel *secondAttemp;
@property (weak, nonatomic) IBOutlet UILabel *result;

@end
