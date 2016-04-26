## Matchismo

Stanford iOS7 Assignment

Use Xcode 7.3 AND OS X EI Captian 10.11.4

## version1.0
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

## version2.0

### version2.1
>更新时间：2016.04.24

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

添加`Model`类`PlayingCard`，父类是`Card`。`PlayingCard.h`内容为：

```objc
@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSString *)validSuits;
+ (NSUInteger)maxRank;

@end
```

`suit`属性存放牌面花色；`rank`属性存放牌面数值；类方法`validSuits`返回当前牌类可以使用花色字符串(这里为`@[@"♠︎", @"♣︎", @"♥︎", @"♦︎"]`)；类方法`maxRank`返回当前牌面可以支持的最大数值(当前为13)。

`PlayingCard.m`中需要重载`contents`方法：

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

### version2.2