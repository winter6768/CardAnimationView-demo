//
//  CardAnimationView.m
//  CardAnimationView-demo
//
//  Created by 杨艳东 on 2016/12/29.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "CardAnimationView.h"

@interface CardAnimationView ()<CardItemViewDelegate>
{
    NSInteger cardItemCount;
    
    NSInteger topIndex;
}

extern NSInteger const constTag;


@end

@implementation CardAnimationView

NSInteger const constTag = 700;

-(void)removeTopItemInTheLeft:(BOOL)isleft
{
    CardItemView *view_item = [self viewWithTag:constTag + topIndex];
    
    if (view_item)
    {
        [view_item removeWithLeft:isleft];
    }
}


-(void)reloadData
{    
    if (_dataSource == nil)
    {
        return;
    }
    
    cardItemCount = [self numberOfItemViews];
    
    for (int i = 0; i < cardItemCount; i ++)
    {
        CardItemView *view_item = [self viewWithTag:constTag + topIndex + i];

        if (view_item)
        {
            view_item.transform = CGAffineTransformIdentity;
        }
        else
        {
            view_item = [self itemViewAtIndex:i];
            view_item.delegate = self;
            [self addSubview:view_item];
        }
        
        [self sendSubviewToBack:view_item];

        view_item.lab_name.alpha = !i;
        
        view_item.tag = constTag + i;
        view_item.frame = CGRectMake(0, 0, self.cardItemSize.width, self.cardItemSize.height);
        
        CGPoint point = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        view_item.startPoint = point;
        
        point.y += pointYBlock(i);
        view_item.center = point;
        
        view_item.transform = transformBlock(i);
    }
    
    topIndex = 0;
}

- (NSInteger)numberOfItemViews
{
    if ([self.dataSource respondsToSelector:@selector(numberOfItemViewsInCardView:)])
    {
        return [self.dataSource numberOfItemViewsInCardView:self];
    }
    return 0;
}

- (CardItemView *)itemViewAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(cardAnimationView:itemViewAtIndex:)])
    {
        CardItemView *itemView = [self.dataSource cardAnimationView:self itemViewAtIndex:index];
        
        if (itemView)
        {
            return itemView;
        }
    }
    
    return [[CardItemView alloc] init];
}

- (void)cardItemView:(CardItemView *)cardItemView didRemoveInTheLeft:(BOOL)isLeft
{
    topIndex = cardItemView.tag - constTag + 1;
    
    for (int i = 0; i < 2; i ++)
    {
        CardItemView *items = [self viewWithTag:cardItemView.tag + i + 1];
        
        CGPoint point = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        point.y += pointYBlock(i);
        
        CGAffineTransform transform = transformBlock(i);
        
        [UIView animateWithDuration:.3 animations:^{
            
            if (i == 0)
            {
                items.lab_name.alpha = 1;
            }
            
            items.center = point;
            items.transform = transform;
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(cardAnimationView:didDisappearInTheLeft:)])
    {
        [self.delegate cardAnimationView:self didDisappearInTheLeft:isLeft];
    }
    
    if (cardItemCount > 0)
    {
        cardItemCount -= 1;
        
        if (cardItemCount - topIndex < 4)
        {
            if ([self.dataSource respondsToSelector:@selector(cardAnimationViewNeedMoreData:)])
            {
                [self.dataSource cardAnimationViewNeedMoreData:self];
            }
        }
    }
}

-(void)cardItemView:(CardItemView *)cardItemView didMove:(CGFloat)moveScale
{
//    NSLog(@"%f-- ",moveScale);
    
    for (int i = 0; i < 2; i ++)
    {
        CardItemView *items = [self viewWithTag:cardItemView.tag + i + 1];
        
        CGPoint point = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        
        point.y += (20 * (i + moveScale));
        
        CGFloat scale = 1 - .05 * (i + moveScale);
        
        items.center = point;
        items.transform = CGAffineTransformMakeScale(scale, scale);
        
        if (i == 0)
        {
            items.lab_name.alpha = 1 - moveScale;
        }
    }
}

-(void)cardItemViewDidMoveCancel:(CardItemView *)cardItemView
{
    for (int i = 0; i < 2; i ++)
    {
        CardItemView *items = [self viewWithTag:cardItemView.tag + i + 1];
        
        CGPoint point = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        point.y += pointYBlock(i + 1);
        
        CGAffineTransform transform = transformBlock(i + 1);
        
        [UIView animateWithDuration:.3 animations:^{
            
            if (i == 0)
            {
                items.lab_name.alpha = 0;
            }
            
            items.center = point;
            items.transform = transform;
        }];
    }
}

#pragma mark - block

CGFloat pointYBlock(NSInteger index) {
    
    return MIN(40 , 20 * index);
};

CGAffineTransform transformBlock(NSInteger index){
    
    return CGAffineTransformMakeScale(MAX(.9, 1 - .05 * index), MAX(.9, 1 - .05 * index));
}

@end
