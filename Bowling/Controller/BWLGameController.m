//
//  ViewController.m
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLGameController.h"
#import "BWLPlayerViewController.h"
#import "KeepLayout.h"
#import "BWLScoreCard.h"
@interface BWLGameController ()

@property (strong,nonatomic) NSArray *playersCards;
@property (strong, nonatomic)NSMutableArray *playersGames;
@property (strong, nonatomic)BWLPlayerViewController *player;
@end

@implementation BWLGameController
static int yOffset = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    for(int i = 0;i < self.playersCards.count;i++) {
        self.player = [[BWLPlayerViewController alloc]initWithPlayer:self.playersCards[i]];//create new instance
        [self.view addSubview:self.player.playerView];
        self.player.playerView.keepTopInset.equal = KeepRequired(90 + yOffset);
        self.player.playerView.keepLeftInset.equal = KeepRequired(10);
        self.player.playerView.keepRightInset.equal = KeepRequired(10);
        self.player.playerView.keepHeight.equal = KeepRequired(100);
        [self.player createGameForPlayer];
        [self.playersGames addObject:self.player];
        yOffset+=150;
        
    }
    
}

- (id)initWithScoreCards:(NSArray *)playersCards {
    self = [super init];
    if (self) {
        self.playersCards = playersCards;
    }
    return self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
