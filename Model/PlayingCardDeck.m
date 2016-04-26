//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Yofer Zhang on 16/4/26.
//  Copyright © 2016年 Yofer Zhang. All rights reserved.
//

#import "PlayingCardDeck.h"


@implementation PlayingCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                
                [self addCard:card]; // superclass method
            }
        }
    }
    
    return self;
} // init

@end
