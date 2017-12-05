//
//  BWLResultController.m
//  Bowling
//
//  Created by Aleksey Drachyov on 11/2/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "BWLResultController.h"
#import "BWLResultController_BWLExtension.h"
#import "CustomCellForResult.h"
#import "BWLScoreCard.h"
@interface BWLResultController ()
@property (nonatomic, strong)NSArray *playersCards;
@end

@implementation BWLResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CustomCellForResult" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ResultID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (id)initWithScoreCards:(NSArray *)playersCards {
    self = [super init];
    if (self) {
        self.playersCards = playersCards;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playersCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resultIdentificator = @"ResultID";
    CustomCellForResult *cell = (CustomCellForResult *)[tableView dequeueReusableCellWithIdentifier:resultIdentificator forIndexPath:indexPath];
    BWLScoreCard *scoreCard = self.playersCards[indexPath.row];
    cell.title.text = scoreCard.playerName;
    cell.score.text = [NSString stringWithFormat:@"%ld",(long)scoreCard.score];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
