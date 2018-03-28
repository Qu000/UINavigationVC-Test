//
//  ViewController.m
//  UINavigationVC-Test
//
//  Created by qujiahong on 2018/3/27.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "ViewController.h"
#import "JHTopView.h"
#import <YYKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define JHRGB(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define JHRGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
/** title数据源*/
@property (nonatomic, strong) NSArray * dataList;
@property (nonatomic, strong) JHTopView * topView;
@end

@implementation ViewController

-(NSArray *)dataList{
    if (!_dataList) {
        _dataList = @[@"左",@"中",@"右"];
    }
    return _dataList;
}

-(JHTopView *)topView{
    if (!_topView) {
        _topView = [[JHTopView alloc]initWithFrame:CGRectMake(0, 0, 200, 50) titleNames:self.dataList];
        
        @weakify(self);
        _topView.block = ^(NSInteger tag) {
            @strongify(self);
            CGPoint point = CGPointMake(tag * SCREEN_WIDTH, self.contentScrollView.contentOffset.y);
            [self.contentScrollView setContentOffset:point animated:YES];
            
        };
    }
    return _topView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


- (void)setupUI{
    
    [self setupNav];
    
    [self setupChildVC];
}
- (void)setupNav{
    self.navigationController.navigationBar.barTintColor = JHRGB(76, 201, 245);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"global_search"] style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"title_button_more"] style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.titleView = self.topView;
}

- (void)setupChildVC{
    NSArray * vcName = @[@"JHLeftVC",@"JHMiddleVC",@"JHRightVC"];
    for (NSInteger i=0; i<vcName.count; i++) {
        
        NSString *vcNameStr = vcName[i];
        
        UIViewController * vc = [[NSClassFromString(vcNameStr) alloc]init];
        vc.title = self.dataList[i];
        [self addChildViewController:vc];
    }
    
    //设置scrollView的contentSize
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.dataList.count, 0);
    
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    //默认先展示第二个界面
    self.contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    
    //进入主控制器时加载页面
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

#pragma mark --- UIScrollViewDelegate
//减速结束时调用。加载子控制器view
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    CGFloat offset = scrollView.contentOffset.x;
    
    //获取第几个  的索引值
    NSInteger idx = offset / width;
    
    //传递联动索引值给topView
    [self.topView scrolling:idx];
    
    //根据索引值，返回vc的引用
    UIViewController * vc = self.childViewControllers[idx];
    
    //判读当前vc是否执行过viewDidLoad
    if ([vc isViewLoaded]) return;
    
    //设置子控制器view的大小
    vc.view.frame = CGRectMake(offset, 0, width, height);
    
    //将子控制器view加入到scrollView上
    [scrollView addSubview:vc.view];
}

//动画结束时调用(点击topView的button时，走的代理;因为topView中button的改变，不会走scrollViewDidEndDecelerating)
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
