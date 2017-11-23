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
#import "BWLResultController.h"
@interface BWLRegistrationController ()
@property (weak, nonatomic) IBOutlet UITableView *registrationTableView;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *playersCards;
@end

@implementation BWLRegistrationController
enum RowType {
    RowTypePlayer = -1,
    RowTypeTextField ,
    RowTypeButton ,
    count};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.players = [NSMutableArray new];
    self.playersCards = [NSMutableArray new];
    self.registrationTableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.players.count + count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textFieldIdentifier = @"MyIDForText";
    static NSString *buttonIdentifier = @"MyIDForButton";
    enum RowType kindOfCell = [self kindOfCell:indexPath];
    switch (kindOfCell) {
        case RowTypePlayer: {
            CustomCellForTextField *cell = (CustomCellForTextField *)[tableView dequeueReusableCellWithIdentifier:textFieldIdentifier forIndexPath:indexPath];
            cell.textField.text = [NSString stringWithFormat:@"%@",self.players[indexPath.row]] ;
            return cell;
            break;
        }
        case RowTypeTextField: {
            CustomCellForTextField *cell = (CustomCellForTextField *)[tableView dequeueReusableCellWithIdentifier:textFieldIdentifier forIndexPath:indexPath];
            __weak typeof(self) _self_weak = self;
            
            [cell setActionBlock:^{
                NSIndexPath *indexPathForNextRow = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
                [_self_weak enableButton:indexPathForNextRow];
            }];
            return cell;
            break;
        }
        case RowTypeButton: {
            CustomCellForButton *cell = (CustomCellForButton *)[tableView dequeueReusableCellWithIdentifier:buttonIdentifier forIndexPath:indexPath];
            cell.addPlayerButton.enabled = NO;
            __weak typeof(self) _self_weak = self;
            [cell setActionBlock:^{
                NSIndexPath *indexPathForPrevRow = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
                [_self_weak addPlayer:indexPathForPrevRow];
                
            }];
            return cell;
            break;
        }
        default:
            break;
        }
    return nil;
    
}

- (enum RowType)kindOfCell:(NSIndexPath *)indexPath {
    if (indexPath.row < self.players.count) {
        return RowTypePlayer;
    } else if (indexPath.row == self.players.count) {
        return RowTypeTextField;
    } else {
        return RowTypeButton;
    }
}

- (void)enableButton:(NSIndexPath *)indexPath {
    NSIndexPath *indexPathForPrevRow = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
    CustomCellForButton *cell = [self.registrationTableView cellForRowAtIndexPath:indexPath];
    CustomCellForTextField *cellText = [self.registrationTableView cellForRowAtIndexPath:indexPathForPrevRow];
    if([cellText.textField.text isEqualToString:@""]) {
        cell.addPlayerButton.enabled = NO;
    } else {
        cell.addPlayerButton.enabled = YES;
    }
}

- (void)addPlayer:(NSIndexPath *)indexPath {
    CustomCellForTextField *cell = [self.registrationTableView cellForRowAtIndexPath:indexPath];
    if (!([cell.textField.text isEqualToString:@"Enter name"] || [cell.textField.text isEqualToString:@""])) {
        [self.players addObject:cell.textField.text];
        [self.registrationTableView reloadData];
    }
    
}

- (IBAction)startGameButton:(id)sender {
    [self createScoreCards];
    BWLResultController *res = [[BWLResultController alloc]initWithScoreCards:self.playersCards];
    [self.navigationController pushViewController:res animated:YES];
}

- (void)createScoreCards {
    for (int i= 0; i < self.players.count; i++) {
        BWLScoreCard *scoreCard = [[BWLScoreCard alloc]initWithName:self.players[i]];
        [self.playersCards addObject:scoreCard];
        NSLog(@"%@",scoreCard.playerName);
    }
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
