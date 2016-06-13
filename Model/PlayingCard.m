//
//  PlayingCard.m
//  Matchismo
//
//  Created by Yofer Zhang on 16/4/23.
//  Copyright © 2016年 Yofer Zhang. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

#pragma mark - Overridden methods

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        
        if (otherCard.rank == self.rank) {
            score = 4;
        } else if ([otherCard.suit isEqualToString:self.suit]){
            score = 1;
        }
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
//    NSString *errorTag = @"Error: ";
//    NSString *errorString = @"premature end of file.";
//    NSString *errorMessage = [errorTag stringByAppendingString:errorString];
//    produces the string “Error: premature end of file.”.
    
} // contents

@synthesize suit = _suit; // Because we provide setter AND getter

#pragma mark - Custom Accessors

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
} // setSuit:

- (NSString *)suit
{
    return _suit ? _suit : @"?";
} // suit

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
} // setRank:

#pragma mark - Private

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
} // rankStrings

#pragma mark - Public

+ (NSArray *)validSuits
{
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
    
} // validSuits

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
} // maxRank



@end
