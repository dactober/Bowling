//
//  CustomCellForButton.m
//  Bowling
//
//  Created by admin on 11/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "CustomCellForButton.h"
@interface CustomCellForButton()
@end

@implementation CustomCellForButton

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.addPlayerButton addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
    // Configure the view for the selected state
}

- (void)buttonTouch {
    if (self.buttonActionBlock != nil) {
        self.buttonActionBlock();
    }
}

@end
