//
//  FileManagerHelper.m
//  Bowling
//
//  Created by admin on 12/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "BWLFileManagerHelper.h"

static NSString * const kWinner = @"winner";
@interface BWLFileManagerHelper()
@property (nonatomic, strong) NSArray<BWLWinnerOfGame *> *winners;
@end

@implementation BWLFileManagerHelper
static NSString * const kPathToPlistFile = @"WinnersPropertyList";

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadWinners];
    }
    return self;
}

- (BOOL)addWinner:(BWLWinnerOfGame *)winner {
    NSMutableArray *newList = [self.winners mutableCopy];
    [newList addObject:winner];
    self.winners = [newList copy];
    return [self saveWinners];
}

#pragma mark - Private
- (void)loadWinners {
    NSString *plistPath = [self plistPath];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *dataList = dict[kWinner];
    if (dataList == nil) {
        self.winners = [NSMutableArray new];
    } else {
        self.winners = [self winnerListFromDataList:dataList];
    }
}

- (BOOL)saveWinners {
    NSString *plistPath = [self plistPath];
    NSMutableDictionary * dict = [NSMutableDictionary new];
    dict[kWinner] = [self dataListFromWinnerList:self.winners];
    return [dict writeToFile:plistPath atomically:YES];
}

- (NSString *)plistPath {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectoryPath stringByAppendingPathComponent:kPathToPlistFile];
    return plistPath;
}

-(NSArray <BWLWinnerOfGame *> *)winnerListFromDataList:(NSArray<NSData *> *)array {
    NSMutableArray <BWLWinnerOfGame *> *mutableArray = [NSMutableArray new];
    for (NSData *data in array) {
        BWLWinnerOfGame *winner = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [mutableArray addObject:winner];
    }
    return [mutableArray copy];
}

- (NSArray<NSData *> *)dataListFromWinnerList:(NSArray <BWLWinnerOfGame *> *)list {
    NSMutableArray <NSData *> *mutableArray = [NSMutableArray new];
    for (BWLWinnerOfGame *winner in list) {
        NSData *winnerData = [NSKeyedArchiver archivedDataWithRootObject:winner];
        [mutableArray addObject:winnerData];
    }
    return [mutableArray copy];
}

@end
