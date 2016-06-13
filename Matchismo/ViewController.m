//
//  ViewController.m
//  Matchismo
//
//  Created by Yofer Zhang on 16/4/23.
//  Copyright © 2016年 Yofer Zhang. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ViewController

#pragma mark - Custom Accessors

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self creatDeck]];
    }
    
    return _game;
} // game

//- (Deck *)deck
//{
//    if (!_deck) {
//        _deck = [self creatDeck];
//    }
//    
//    return _deck;
//} // deck

- (Deck *)creatDeck
{
    return [[PlayingCardDeck alloc] init];
} // creatDeck

//- (void)setFlipCount:(int)flipCount
//{
//    _flipCount = flipCount;
//    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
//    
//} // setFlipCount:

#pragma mark - IBAction

- (IBAction)touchCardButton:(UIButton *)sender
{
    
//    if ([sender.currentTitle length]) {
//        [sender setBackgroundImage:[UIImage imageNamed:@"CardBack"]
//                          forState:UIControlStateNormal];
//        [sender setTitle:@"" forState:UIControlStateNormal];
//    } else {
//        Card *randomcard = [self.deck drawRandomCard]; // draw a card
//        
//        // Protect against an empty deck.
//        if (randomcard) {
//            [sender setBackgroundImage:[UIImage imageNamed:@"CardFront"]
//                              forState:UIControlStateNormal];
//            [sender setTitle:randomcard.contents
//                    forState:UIControlStateNormal];
//        }
//    }
    
    unsigned long chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    
    // update flipCount in there
    // because every time touch the button, this method will be call
//    self.flipCount++;
    
} // touchCardButton:



- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        unsigned long cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
} // updateUI

#pragma mark - Helper Methods

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
} // titleForCard:

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"CardFront" : @"CardBack"];
}

@end



