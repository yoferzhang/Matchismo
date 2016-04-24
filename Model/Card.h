//
//  Card.h
//  Matchismo
//
//  Created by Yofer Zhang on 16/4/23.
//  Copyright © 2016年 Yofer Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

// contents is the content displayed on the card front
@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
