//
//  JHTopView.h
//  UINavigationVC-Test
//
//  Created by qujiahong on 2018/3/27.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TopBlock)(NSInteger tag);

@interface JHTopView : UIView
-(instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titles;

@property ( nonatomic, copy) TopBlock block;

-(void)scrolling:(NSInteger)idx;

@end
