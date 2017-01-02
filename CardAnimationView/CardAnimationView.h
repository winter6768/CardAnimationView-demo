//
//  CardAnimationView.h
//  CardAnimationView-demo
//
//  Created by 杨艳东 on 2016/12/29.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardItemView.h"

@class CardAnimationView,CardItemView;

@protocol CardAnimationViewDelegate <NSObject>

/** 移除的数据要同时把数据源中的对应数据也移除掉 */
-(void)cardAnimationView:(CardAnimationView *)cardAnimationView didDisappearInTheLeft:(BOOL)isLeft;

@end

@protocol CardAnimationViewDataSource <NSObject>

-(NSInteger)numberOfItemViewsInCardView:(CardAnimationView *)cardAnimationView;

-(CardItemView *)cardAnimationView:(CardAnimationView *)cardAnimationView itemViewAtIndex:(NSInteger)index;

-(void)cardAnimationViewNeedMoreData:(CardAnimationView *)cardAnimationView;

@end

@interface CardAnimationView : UIView

@property(nonatomic,assign)CGSize cardItemSize;

@property(nonatomic,weak)id <CardAnimationViewDelegate> delegate;
@property(nonatomic,weak)id <CardAnimationViewDataSource> dataSource;

-(void)reloadData;

-(void)removeTopItemInTheLeft:(BOOL)isleft;

@end
