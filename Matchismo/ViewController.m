//
//  ViewController.m
//  Matchismo
//
//  Created by Yofer Zhang on 16/4/23.
//  Copyright © 2016年 Yofer Zhang. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;

@end

@implementation ViewController

- (Deck *)deck
{
    if (!_deck) {
        _deck = [self creatDeck];
    }
    
    return _deck;
} // deck

- (Deck *)creatDeck
{
    return [[PlayingCardDeck alloc] init];
} // creatDeck

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    
} // setFlipCount:

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"CardBack"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        Card *randomcard = [self.deck drawRandomCard]; // draw a card
        
        // Protect against an empty deck.
        if (randomcard) {
            [sender setBackgroundImage:[UIImage imageNamed:@"CardFront"]
                              forState:UIControlStateNormal];
            [sender setTitle:randomcard.contents
                    forState:UIControlStateNormal];
        }
    }
    
    // update flipCount in there
    // because every time touch the button, this method will be call
    self.flipCount++;
    
} // touchCardButton:


@end
