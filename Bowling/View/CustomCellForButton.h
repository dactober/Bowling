//
//  CustomCellForButton.h
//  Bowling
//
//  Created by admin on 11/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonActionBlock)(void);

@interface CustomCellForButton : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;
@property (nonatomic, copy) ButtonActionBlock buttonActionBlock;
@end
