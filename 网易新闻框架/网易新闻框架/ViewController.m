//
//  ViewController.m
//  网易新闻框架
//
//  Created by 码农界四爷__King on 16/5/24.
//  Copyright © 2016年 码农界四爷__King. All rights reserved.
//

#import "ViewController.h"
#import "SYHotViewController.h"
#import "SYVideoViewController.h"
#import "SYReaderViewController.h"
#import "SYScienceViewController.h"
#import "SYScoletyViewController.h"
#import "SYToplineViewController.h"

#define SYScreenW [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *titleScroll;
@property (nonatomic,weak) UIScrollView *contentView;
@property (nonatomic,weak) UIButton *selBtn;
@property (nonatomic,strong) NSMutableArray *buttons;
@end

@implementation ViewController

- (NSMutableArray *)buttons{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置头部滚动
    [self setupTopTitleScrollView];
    //设置底部滚动视图
    [self setupContentScrollView];
    //设置所有的控制器
    [self setupAllChildViewCroller];
    //设施头部滚动视图标题
    [self setupTopTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupTopTitle
{
    CGFloat count = self.childViewControllers.count;
    CGFloat w = 80;
    CGFloat h = 35;
    CGFloat x = 0;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        x = i * w;
        btn.frame = CGRectMake(x, 0, w, h);
        
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScroll addSubview:btn];
        [self.buttons addObject:btn];
        if (i == 0) {
            [self btnClick:btn];
        }
    }
    self.titleScroll.contentSize = CGSizeMake(count * w, 0);
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    
    self.contentView.contentSize = CGSizeMake(count * SYScreenW, 0);
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.bounces = NO;
    self.contentView.pagingEnabled = YES;
    
    self.contentView.delegate = self;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = scrollView.contentOffset.x / SYScreenW;
    UIButton *btn = self.buttons[i];
    [self selBtn:btn];
    [self setupOneChildViewController:i];
}

- (void)setupOneChildViewController:(NSInteger)i{
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview == nil) {
        CGFloat x = i * [UIScreen mainScreen].bounds.size.width;
        vc.view.frame = CGRectMake(x, 0, SYScreenW, self.contentView.frame.size.height);
        [self.contentView addSubview:vc.view];
    }
}

- (void)btnClick:(UIButton *)btn
{
    
    NSLog(@"123");
    //选中按钮之后取消前一个按钮的颜色
    [self selBtn:btn];
    NSInteger i = btn.tag;
    [self setupOneChildViewController:i];
    CGFloat x = i * [UIScreen mainScreen].bounds.size.width;
    self.contentView.contentOffset = CGPointMake(x, 0);
    
}

- (void)selBtn:(UIButton *)button
{
    [_selBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _selBtn = button;
}
- (void)setupAllChildViewCroller
{
    SYHotViewController *hot = [[SYHotViewController alloc]init];
    hot.title = @"热点";
    [self addChildViewController:hot];
    
    SYVideoViewController *video = [[SYVideoViewController alloc]init];
    video.title = @"视频";
    [self addChildViewController:video];
    
    SYReaderViewController *reader = [[SYReaderViewController alloc]init];
    reader.title = @"订阅";
    [self addChildViewController:reader];
    
    SYScienceViewController *science = [[SYScienceViewController alloc]init];
    science.title = @"科技";
    [self addChildViewController:science];
    
    SYScoletyViewController *scolety = [[SYScoletyViewController alloc]init];
    scolety.title = @"社会";
    [self addChildViewController:scolety];
    
    SYToplineViewController *top = [[SYToplineViewController alloc]init];
    top.title = @"头条";
    [self addChildViewController:top];
}
- (void)setupTopTitleScrollView
{
    UIScrollView *titleScroll = [[UIScrollView alloc]init];
    CGFloat y = 64;
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = 35;
    titleScroll.frame = CGRectMake(0, y, w, h);
    //    titleScroll.backgroundColor = [UIColor redColor];
    self.titleScroll = titleScroll;
    [self.view addSubview:titleScroll];
}

- (void)setupContentScrollView{
    UIScrollView *contentView = [[UIScrollView alloc]init];
    CGFloat y = CGRectGetMaxY(self.titleScroll.frame);
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height - y;
    contentView.frame = CGRectMake(0, y, w, h);
    contentView.backgroundColor = [UIColor blueColor];
    self.contentView = contentView;
    [self.view addSubview:contentView];
}
@end
