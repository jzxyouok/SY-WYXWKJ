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
//顶部按钮背景
@property (nonatomic,weak) UIScrollView *titleScroll;
//底部视图滚动背景
@property (nonatomic,weak) UIScrollView *contentView;
//定义一个Button,用于被点击按钮
@property (nonatomic,weak) UIButton *selBtn;
//定义一个数组，用来储存顶部按钮
@property (nonatomic,strong) NSMutableArray *buttons;
@end

@implementation ViewController
//初始化
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
    //因为iOS7之后 导航控制器下，系统会自动往下偏移64的单位，所以我们要把系统的默认值设置为NO，如果不设置这个属性，按钮上的文字将显示不出来。
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupTopTitle
{
    
    //根据控制器的数量来确定顶部按钮的数量
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
    //把按钮添加到设置好的顶部背景上
        [self.titleScroll addSubview:btn];
        //把按钮添加到数组以方便以后取用
        [self.buttons addObject:btn];
        //默认为第一个按钮
        if (i == 0) {
            [self btnClick:btn];
        }
    }
    //设置顶部按钮背景的范围
    self.titleScroll.contentSize = CGSizeMake(count * w, 0);
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    //设置底部背景的范围
    self.contentView.contentSize = CGSizeMake(count * SYScreenW, 0);
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.bounces = NO;
    self.contentView.pagingEnabled = YES;
    //设置代理
    self.contentView.delegate = self;
    
}

//减速完成调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = scrollView.contentOffset.x / SYScreenW;
    //获取按钮标题
    UIButton *btn = self.buttons[i];
    //选中标题
    [self selBtn:btn];
    //切换界面
    [self setupOneChildViewController:i];
}
//抽取的公用方法，此方法是切换控制的View
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
    //设置按钮选中状态
    [self selBtn:btn];
    //根据按钮的tag来确定对应的控制器
    NSInteger i = btn.tag;
    [self setupOneChildViewController:i];
    CGFloat x = i * [UIScreen mainScreen].bounds.size.width;
    //设置底部控制器的contentOffset的尺寸
    self.contentView.contentOffset = CGPointMake(x, 0);

}

- (void)selBtn:(UIButton *)button
{
    //按钮默认大小
    _selBtn.transform = CGAffineTransformIdentity;
    //默认按钮文字颜色为黑色，点击之后变成红色
    [_selBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    
    //选中按钮居中
    //选中的按钮的中心点减去屏幕宽度的一半就是要移动的距离
    CGFloat offsetX = button.center.x - SYScreenW * 0.5;
    
    //处理左右按钮的最大偏移量
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    CGFloat MaxOffsetX = self.titleScroll.contentSize.width - SYScreenW;
    if (offsetX > MaxOffsetX) {
        offsetX = MaxOffsetX;
    }
    //设置动画
    [self.titleScroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    _selBtn = button;
}
//正在滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger leftI = scrollView.contentOffset.x / SYScreenW;
    NSInteger rightI =leftI + 1;
    
    UIButton *leftBTn = self.buttons[leftI];
    UIButton *rightBtn = nil;
    NSInteger count = self.buttons.count;
    if (rightI < count) {
        rightBtn = self.buttons[rightI];
    }
    //设置按钮文字的大小缩放
    CGFloat scaleR = scrollView.contentOffset.x / SYScreenW - leftI;
    CGFloat scaleL = 1 - scaleR;
    leftBTn.transform = CGAffineTransformMakeScale(scaleL * 0.3 + 1, scaleL * 0.3 + 1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * 0.3 + 1, scaleR * 0.3 + 1);
    //设置按钮颜色的变化
    UIColor *colorR = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *colorL = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    
    [leftBTn setTitleColor:colorL forState:UIControlStateNormal];
    [rightBtn setTitleColor:colorR forState:UIControlStateNormal];
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
