//
//  Deck.h
//  Matchismo
//
//  Created by Yofer Zhang on 16/4/26.
//  Copyright © 2016年 Yofer Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;
- (NSUInteger)cardsCount;

@end
