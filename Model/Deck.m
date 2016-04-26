//
//  Deck.m
//  Matchismo
//
//  Created by Yofer Zhang on 16/4/26.
//  Copyright © 2016年 Yofer Zhang. All rights reserved.
//

#import "Deck.h"

@interface Deck ()

@property (strong, nonatomic) NSMutableArray *cards; // of Card

@end

@implementation Deck

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
    
} // cards

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
    
} // addCard:atTop

- (void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
    
} // addCard:

- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if ([self.cards count]) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    NSLog(@"%u", (unsigned int)[self.cards count]);
    
    return randomCard;
    
} // drawRandomCard

// for test
- (NSUInteger)cardsCount
{
    return [_cards count];
    
} // cardsCount


@end
