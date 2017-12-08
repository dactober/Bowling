//
//  BWLResultController.m
//  Bowling
//
//  Created by Aleksey Drachyov on 11/2/17.
//  Copyright © 2017 Aleksey Drachyov. All rights reserved.
//

#import "BWLResultController.h"
#import "CustomCellForResult.h"
#import "BWLScoreCard.h"
#import "BWLMapViewController.h"
#import "NotificationConstants.h"
@interface BWLResultController ()
@property (nonatomic, strong) NSArray *playersCards;
@property (nonatomic, strong) NSString *nameOfWinner;
@property (nonatomic) NSInteger maxScore;
@property (nonatomic, strong) id<MKAnnotation> annotation;
@property (nonatomic, strong) BWLWinnerOfGame *winnerOfGame;
@end

@implementation BWLResultController
- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CustomCellForResult" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ResultID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back to main screen" style:UIBarButtonItemStylePlain target:self action:@selector(returnToMainScreenButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)returnToMainScreenButtonPressed {
    self.winnerOfGame.name = self.nameOfWinner;
    self.winnerOfGame.score = @(self.maxScore);
    [self postNotificationWithWinner:self.winnerOfGame andLocation:self.annotation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)postNotificationWithWinner:(BWLWinnerOfGame *)winnerOfGame andLocation:(id<MKAnnotation>)annotation {
    NSDictionary *dictionary = @{kWinner : winnerOfGame,
                                kLocation : annotation};
    [[NSNotificationCenter defaultCenter] postNotificationName:kEndGameNotification object:nil userInfo:dictionary];
}

- (id)initWithScoreCards:(NSArray *)playersCards winner:(BWLWinnerOfGame *)winner andAnnotation:(id<MKAnnotation>)annotation {
    self = [super init];
    if (self) {
        self.playersCards = playersCards;
        self.annotation = annotation;
        self.winnerOfGame = winner;
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
    if (scoreCard.score > self.maxScore) {
        self.nameOfWinner = scoreCard.playerName;
        self.maxScore = scoreCard.score;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
