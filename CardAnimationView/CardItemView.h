//
//  CardItemView.h
//  CardAnimationView-demo
//
//  Created by 杨艳东 on 2016/12/29.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardItemView;

@protocol CardItemViewDelegate <NSObject>

-(void)cardItemView:(CardItemView *)cardItemView didRemoveInTheLeft:(BOOL)isLeft;

-(void)cardItemView:(CardItemView *)cardItemView didMove:(CGFloat)moveScale;

-(void)cardItemViewDidMoveCancel:(CardItemView *)cardItemView;

@end

@interface CardItemView : UIView

@property (nonatomic, weak) id <CardItemViewDelegate> delegate;

@property(nonatomic,assign)CGPoint startPoint;

@property(nonatomic,assign)CGFloat nameAlpha;

- (void)removeWithLeft:(BOOL)left;

@end
