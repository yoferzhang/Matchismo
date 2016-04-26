## Matchismo

Stanford iOS7 Assignment

Use Xcode 7.3 AND OS X EI Captian 10.11.4

## 简单牌面翻转
>更新时间：2016.04.22

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
##添加`Deck`类

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

