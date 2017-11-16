//
//  ViewController.m
//  Bowling
//
//  Created by admin on 11/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "ViewController.h"
#import "BWLScoreGridView.h"
#import "BWLScoreGridResultView.h"
#import "KeepLayout.h"
@interface ViewController ()
@property (strong, nonatomic)  BWLScoreGridView *scoreGridView;
@property(strong,nonatomic) BWLScoreGridResultView *scoreGridResultView;
@property (strong, nonatomic) IBOutlet UIView *viewController;
@property (strong,nonatomic) NSMutableArray *views;
@end

@implementation ViewController
const int height = 50;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.views = [NSMutableArray new];
    [self.views addObject:([self createFirstFrame])];
    [self addBowlingFrames];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (BWLScoreGridView *)createFirstFrame {
    BWLScoreGridView* grid = [[BWLScoreGridView alloc] initWithFrame:CGRectMake(0, 0, 0,  0)];
    [self.viewController addSubview:grid];
    grid.keepLeftInset.equal = KeepRequired(0);
    grid.keepTopInset.equal = KeepRequired(0);
    grid.keepHeight.equal = KeepRequired(height);
    return grid;
}
- (BWLScoreGridResultView *)createLastFrame {
    BWLScoreGridResultView* grid = [[BWLScoreGridResultView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    BWLScoreGridView *prevGrid = [self.views lastObject];
    [self.viewController addSubview: grid];
    grid.keepTopInset.equal = KeepRequired(0);
    grid.keepRightInset.equal = KeepRequired(0);
    grid.keepLeftOffsetTo(prevGrid).equal = KeepRequired(0);
    return grid;
}
- (BWLScoreGridView *)createFrame {
    BWLScoreGridView *grid = [[BWLScoreGridView alloc]initWithFrame:CGRectMake(0, 0, 0,  0)] ;
    BWLScoreGridView *prevGrid = [self.views lastObject];
    [self.viewController addSubview:grid];
    grid.keepTopInset.equal = KeepRequired(0);
    grid.keepLeftOffsetTo(prevGrid).equal = KeepRequired(0);
    return grid;
}
- (void)addBowlingFrames {
    for (int i = 1; i < 10; i++) {
        if(i < 9) {
            BWLScoreGridView *grid = [self createFrame];
            [self.views addObject:grid];

       } else {
           BWLScoreGridResultView *grid = [self createLastFrame];
           [self.views addObject:grid];
       }
    }
    [self.views keepWidthsEqual];
    [self.views keepHeightsEqual];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
