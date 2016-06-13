## Matchismo

Stanford iOS7 Assignment

Use Xcode 7.3 AND OS X EI Captian 10.11.4

>更新时间：2016.04.22

## 简单牌面翻转

修改`Main.storyboard`：设置背景色，添加一个`Button`，添加背景图和前景图。设置`Title`为`A♣︎`。并在`ViewController.m`中添加一个方法：

```objc
- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"CardBack"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"CardFront"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"A♣︎" forState:UIControlStateNormal];
    }
    
    // update flipCount in there
    // because every time touch the button, this method will be call
    self.flipCount++;
}
```

接下来添加一个计算翻转次数的`Label`，并在`ViewController.m`添加代码：

```objc
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

@end

@implementation ViewController

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}
```

这里还需要在`touchCardButton:`中添加一行代码来更新`flipCount`数据：

```objc
self.flipCount++;
```

>更新时间：2016.04.24

## 添加`Card`类


添加`Model`类`Card`(`Card.h`,`Card.m`)，`Card.h`内容为：

```objc
@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
```

`contents`记录牌面信息，比如`A♣︎`；`chosen`属性表示当前card是否被选中；`matched`属性表示当前card是否匹配。
`match:`方法：当传入参数`otherCards`中只要有一个和自身的`contents`相等，就让得1分，即`score = 1`。

## 添加`PlayingCard`类

添加`Model`类`PlayingCard`，父类是`Card`。`PlayingCard.h`内容为：

```objc
@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
```

`suit`属性存放牌面花色；`rank`属性存放牌面数值；类方法`validSuits`返回当前牌类可以使用花色字符串(这里为`@[@"♠︎", @"♣︎", @"♥︎", @"♦︎"]`)；类方法`maxRank`返回当前牌面可以支持的最大数值(当前为13)。

`PlayingCard.m`中需要重载`contents`属性的`getter`方法：

```objc
- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
    
} // contents

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];

} // rankStrings
```

`PlayingCard.m`其他内容请查看工程源文件。

>更新时间：2016.04.26

## 添加`Deck`类

添加`Model`类`Deck`。用于存放一副牌，`Deck.h`内容：

```objc
@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
```

`addCard:atTop`方法和`addCard:`都是想牌组中添加一张牌，这里是为了演示如果需要一个有参数的函数和另一个无参数的函数做类似的事情，这里所做的效果不是像`C++`一样进行重载，这里是两个完全不同的函数，从这里的函数名也能看出这是两个函数，切记。给出`Deck.m`的内容：

```objc
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
    
    return randomCard;
    
} // drawRandomCard


@end
```
类拓展里面申明了一个数组`cards`用来存放一副牌。`drawRandomCard`方法从牌组中抽出一张牌返回，并从牌组中删掉这张牌。

## 添加`PlayingCardDeck`类

添加`Model`类`PlayingCardDeck`，只在`.m`文件中重载`init`方法：

```objc
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
}
```

生成一副牌组，包含所有`rank`和`suit`的组合。

## 让stroyboard中的牌面随机显示rank和suit

在`ViewController.m`中，添加一个deck属性：

```objc
@property (strong, nonatomic) Deck *deck;
```

然后添加两个方法：

```objc
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
```

`creatDeck`方法创建并返回了一个`PlayingCardDeck`类，用于初始化`deck`属性。
>这里注意父类指针可以指向子类。

然后在`touchCardButton:`方法中修改代码，每次翻到正面时都随机抽出一张牌，然后将牌面`contents`给`Title`。

```objc
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
```

`storyboard`中将牌`Button`的`Title`删掉，然后将`Background`设为`CardBack`，这样初始牌面为背面，并且牌面没有内容，点击之后就会进入`touchCardButton:`的else部分。实现了随机的效果。

>更新时间：2016.05.06

现在需要做一个可以进行匹配的游戏，在界面上需要放置12个`Button`，每行4个，3行，共12个。我这里用AutoLayout，从左边的Container Margin到右边的Container Margin长度为560。每行放置4张牌，如果没有间隔，每张牌的宽度为140，但是为了每张牌中间留出一个小间隙，需要3个间隙，就找到3和4的最小公倍数12。这样设计最后每张牌的宽度即为137，牌与牌之间的间隔都是4，然后加上Constraints。如下图所示：

<center>
![](http://ww2.sinaimg.cn/large/a9c4d5f6jw1f42z3e6qj1j20pf0h4gnx.jpg)
</center>

在iPhone6s上的测试结果如下图所示：
>我更改了PlayingCard.m文件中的validSiuts函数，就是将里面的生成牌Suit的字符换成了彩色的字符，之前全都是黑色的。

<center>
![](http://ww3.sinaimg.cn/large/a9c4d5f6jw1f42zdon6t4j20ae0ijmyr.jpg)
</center>

>更新时间：2016.06.13

## 添加`CardMatchingGame`类

添加`Model`类`CardMatchingGame`，在`.h`文件中添加3个方法和1个属性：

```objc
#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
```

这些就是将要实现的游戏的逻辑。在`.m`文件中添加一个`Class Extension`，将头文件中声明的属性为`readonly`的`score`数据重新声明为`readwrite`，在添加一个私有属性来存放牌组：

```objc
@interface CardMatchingGame ()

@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card

@end
```

接下来实现方法：

```objc

@implementation CardMatchingGame

#pragma mark - Custom Accessors

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
} // cards

#pragma mark - Designed initializer

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            
        }
    }
    
    return self;
} // initWithCardCount:usingDeck

#pragma mark - Public

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
} // cardAtIndex

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (card.isMatched) {
        return;
    }
    

    if (card.isChosen) {
        card.chosen = NO;
    } else {
        // match against other chosen cards
        for (Card *otherCard in self.cards) {
            if (otherCard.isChosen && !otherCard.isMatched) {
                int matchScore = [card match:@[otherCard]];
                
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    otherCard.matched = YES;
                    card.matched = YES;
                    
                } else {
                    self.score -= MISMATCH_PENALTY;
                    otherCard.chosen = NO;
                }
                
                break; // can only choose 2 cards for now
                
            }
        }
        
        self.score -= COST_TO_CHOOSE;
        
        
        card.chosen = YES;
    }
} // chooseCardAtIndex:n

@end
```

接下来需要在`PlayingCard.m`中重写`Card`类中的方法`otherCards`：

```objc
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
```

在`ViewController.m`中`import``CardMatchingGame.h`类，然后需要一个属性：

```objc
@property (strong, nonatomic) CardMatchingGame *game;
```

然后lazily instantiate it：

```objc
- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self creatDeck]];
    }
    
    return _game;
} // game
```

把12个牌按住`Ctrl`拖拽，产生`Outlet Collection：

```ojbc
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
```

将`touchCardButton:`方法中的内容删掉，重新写，为了对比，将删掉的内容注释起来。

```objc
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
```

`deck`方法也不需要了。实现`updateUI`方法：

```objc
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
```

然后添加一个`Label`显示分数：

```objc
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
```

效果如图：

<center>
![](http://ww3.sinaimg.cn/large/a9c4d5f6jw1f4tezo3lz6j20af0iiq4r.jpg)
</center>



