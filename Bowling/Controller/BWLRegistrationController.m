//
//  BWLRegistrationController.m
//  Bowling
//
//  Created by admin on 11/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLRegistrationController.h"
#import "BWLScoreCard.h"
#import "CustomCellForTextField.h"
#import "CustomCellForButton.h"
#import "BWLGameController.h"

enum RowType {
    RowTypePlayer = -1,
    RowTypeTextField,
    RowTypeButton,
    
    RowTypeCount
};

@interface BWLRegistrationController ()

@property (weak, nonatomic) IBOutlet UITableView *registrationTableView;
@property (nonatomic, strong) NSMutableArray *playersCards;
@property (nonatomic, strong) NSDictionary *rowTypeMapping;

@end

@implementation BWLRegistrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playersCards = [NSMutableArray new];
}

- (NSDictionary *)rowTypeMapping {
    if (!_rowTypeMapping) {
        _rowTypeMapping = @{[NSNumber numberWithInt:RowTypeTextField] : @"MyIDForText",
                            [NSNumber numberWithInt:RowTypeButton] : @"MyIDForButton"};
    }
    return _rowTypeMapping;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playersCards.count + RowTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    enum RowType kindOfCell = [self kindOfCell:indexPath];
    switch (kindOfCell) {
        case RowTypePlayer: {
            CustomCellForTextField *cell = [self createCellForPlayer:tableView andIndexPath:indexPath];
            return cell;
        }
        case RowTypeTextField: {
            CustomCellForTextField *cell = [self createCellForTextField:tableView andIndexPath:indexPath];
            return cell;
        }
        case RowTypeButton: {
           CustomCellForButton *cell = [self createCellForButton:tableView andIndexPath:indexPath];
            return cell;
        }
        default:
            break;
        }
    return nil;
    
}

- (CustomCellForTextField *)createCellForTextField:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
        CustomCellForTextField *cell = (CustomCellForTextField *)[tableView dequeueReusableCellWithIdentifier:self.rowTypeMapping[[NSNumber numberWithInt:RowTypeTextField]]  forIndexPath:indexPath];
        [self setActionBlockForTextField:cell andindexPath:indexPath];
        return cell;
}

- (CustomCellForTextField *)createCellForPlayer:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    CustomCellForTextField *cell = (CustomCellForTextField *)[tableView dequeueReusableCellWithIdentifier:self.rowTypeMapping[[NSNumber numberWithInt:RowTypeTextField]] forIndexPath:indexPath];
    BWLScoreCard *scoreCard = self.playersCards[indexPath.row];
    cell.textField.text = [NSString stringWithFormat:@"%@",scoreCard.playerName] ;
    return cell;
}

- (CustomCellForButton *)createCellForButton:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    CustomCellForButton *cell = (CustomCellForButton *)[tableView dequeueReusableCellWithIdentifier:self.rowTypeMapping[[NSNumber numberWithInt:RowTypeButton]]  forIndexPath:indexPath];
    cell.addPlayerButton.enabled = NO;
    [self setActionBlockForButton:cell andindexPath:indexPath];
    return cell;
}

- (void)setActionBlockForTextField:(CustomCellForTextField *)cell andindexPath:(NSIndexPath *)indexPath{
        __weak typeof(self) _self_weak = self;
        [cell setTextEditingActionBlock:^(NSString *text){
            NSIndexPath *indexPathForNextRow = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
            [_self_weak enableButton:indexPathForNextRow textLenght:text.length];
        }];
    
}

- (void)setActionBlockForButton:(CustomCellForButton *)cell andindexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) _self_weak = self;
    [cell setButtonActionBlock:^{
        NSIndexPath *indexPathForPrevRow = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
        [_self_weak addPlayer:indexPathForPrevRow];
    }];
}

- (enum RowType)kindOfCell:(NSIndexPath *)indexPath {
    if (indexPath.row < self.playersCards.count) {
        return RowTypePlayer;
    } else if (indexPath.row == self.playersCards.count) {
        return RowTypeTextField;
    } else {
        return RowTypeButton;
    }
}

- (void)enableButton:(NSIndexPath *)indexPath textLenght:(NSInteger)lenght {
    CustomCellForButton *cell = [self.registrationTableView cellForRowAtIndexPath:indexPath];
    cell.addPlayerButton.enabled = lenght > 0;
}

- (void)addPlayer:(NSIndexPath *)indexPath {
    CustomCellForTextField *cell = [self.registrationTableView cellForRowAtIndexPath:indexPath];
    [self createScoreCard:cell];
    [self.registrationTableView reloadData];
}

- (IBAction)startGameButton:(id)sender {
    BWLGameController *res = [[BWLGameController alloc]initWithScoreCards:self.playersCards];
    [self.navigationController pushViewController:res animated:YES];
}

- (void)createScoreCard:(CustomCellForTextField *)cell {
    BWLScoreCard *scoreCard = [[BWLScoreCard alloc]initWithName:cell.textField.text];
    [self.playersCards addObject:scoreCard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
