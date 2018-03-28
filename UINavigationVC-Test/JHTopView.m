//
//  JHTopView.m
//  UINavigationVC-Test
//
//  Created by qujiahong on 2018/3/27.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHTopView.h"
#import <YYKit.h>

@interface JHTopView()
/** topView的按钮 */
@property (nonatomic, strong) NSMutableArray * buttons;
/** topView按钮下的线条 */
@property (nonatomic, strong)UIView *lineView;
@end

@implementation JHTopView

-(NSArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat btnW = self.frame.size.width/titles.count;
        CGFloat btnH = self.frame.size.height;
        
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString * vcTitle = titles[i];
            [button setTitle:vcTitle forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            
            button.frame = CGRectMake(i*btnW, 0, btnW, btnH);
            
            [button addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
            
            button.tag = i;//设置block的回传
            
            [self addSubview:button];
            
            [self.buttons addObject:button];
            
            if (i == 1) {
                CGFloat h = 2;
                CGFloat y = 40;

                [button.titleLabel sizeToFit];

                self.lineView = [[UIView alloc]init];
                self.lineView.backgroundColor = [UIColor whiteColor];
                self.lineView.height = h;
                self.lineView.width = button.titleLabel.width;
                self.lineView.top = y;
                self.lineView.centerX = button.centerX;
                [self addSubview:self.lineView];
            }
            
        }
    }
    return self;
}

//topView的button点击事件
-(void)clickTitle:(UIButton *)button{
    
    self.block(button.tag);

    //点击按钮，使ScrollView滑动到相应位置(展示相应的子视图控制器)
    [self scrolling:button.tag];
}

//VC滚动时调用
-(void)scrolling:(NSInteger)idx{
    
    UIButton * button = self.buttons[idx];

    //点击按钮，使line滑动到相应位置
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.centerX = button.centerX;
    }];
}
@end
