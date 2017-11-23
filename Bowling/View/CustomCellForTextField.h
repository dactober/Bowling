//
//  CustomCellForTextField.h
//  Bowling
//
//  Created by admin on 11/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TextEditingActionBlock)(NSString *);
@interface CustomCellForTextField : UITableViewCell
@property (strong, nonatomic) IBOutlet UITableViewCell *customCell;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) TextEditingActionBlock textEditingActionBlock;
@end
