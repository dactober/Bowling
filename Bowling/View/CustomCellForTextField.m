//
//  CustomCellForTextField.m
//  Bowling
//
//  Created by admin on 11/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "CustomCellForTextField.h"
@interface CustomCellForTextField()


@end
@implementation CustomCellForTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.textField setTextColor:[UIColor grayColor]];
    [self.textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    // Configure the view for the selected state
}

- (void)textChange {
    if (self.actionBlock != nil) {
        self.actionBlock();
    }
}
@end
