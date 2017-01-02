//
//  CardItemView.m
//  CardAnimationView-demo
//
//  Created by 杨艳东 on 2016/12/29.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "CardItemView.h"

@implementation CardItemView
{
    UIImageView *image_head;
    UILabel *lab_name;
    
    CGFloat _currentAngle;
    BOOL _isLeft;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1;
        [self setupUI];
        
        [self addPanGest];
    }
    
    return self;
}

//layoutSubviews  方法里设置frame的话  frame 会受到 transform 的影响  设置好frame后再改变transform frame不会受影响

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    image_head.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
    lab_name.frame = CGRectMake(0, frame.size.height - 30, frame.size.width, 30);
}


#pragma mark - UI
-(void)setupUI
{
    image_head = [UIImageView new];
    image_head.backgroundColor = [UIColor whiteColor];
    [self addSubview:image_head];
    
    lab_name = [UILabel new];
    lab_name.text = @"香格里拉二";
    lab_name.textColor = [UIColor blackColor];
    [self addSubview:lab_name];
}

-(void)setNameAlpha:(CGFloat)nameAlpha
{
    _nameAlpha = nameAlpha;
    
    lab_name.alpha = nameAlpha;
}

#pragma mark - 手势
- (void)addPanGest
{
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestHandle:)];
    [self addGestureRecognizer:pan];
}

- (void)panGestHandle:(UIPanGestureRecognizer *)panGest
{
    if (panGest.state == UIGestureRecognizerStateChanged)
    {
        CGPoint movePoint = [panGest translationInView:self];
        _isLeft = (movePoint.x < 0);
        
        self.center = CGPointMake(self.center.x + movePoint.x, self.center.y + movePoint.y);
        
        CGFloat angle = (self.center.x - self.frame.size.width / 2.0) / self.frame.size.width / 4.0;
        _currentAngle = angle;
        
        self.transform = CGAffineTransformMakeRotation(angle);
        
        [panGest setTranslation:CGPointZero inView:self];
        
        CGFloat scale = self.center.x / self.startPoint.x;
        
        if (self.center.x > self.startPoint.x)
        {
            scale = 2 - scale;
        }
        
        if (scale < 0 || scale > 1)
        {
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(cardItemView:didMove:)])
        {
            [self.delegate cardItemView:self didMove:scale];
        }
    }
    else if (panGest.state == UIGestureRecognizerStateEnded)
    {
        CGPoint vel = [panGest velocityInView:self];
        
        if (vel.x > 800 || vel.x < - 800)
        {
            [self remove];
            return ;
        }
        
        if (self.frame.origin.x + self.frame.size.width > 150 && self.frame.origin.x < self.frame.size.width - 150)
        {
            if ([self.delegate respondsToSelector:@selector(cardItemViewDidMoveCancel:)])
            {
                [self.delegate cardItemViewDidMoveCancel:self];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.center = self.startPoint;
                self.transform = CGAffineTransformIdentity;
            }];
        }
        else
        {
            [self remove];
        }
    }
}

- (void)remove
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if (_isLeft)  // left
        {
            self.center = CGPointMake(- 1000, self.center.y - _currentAngle * self.frame.size.height);
        }
        else // right
        {
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + _currentAngle * self.frame.size.height);
        }
        
    } completion:^(BOOL finished)
     {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(cardItemView:didRemoveInTheLeft:)])
    {
        [self.delegate cardItemView:self didRemoveInTheLeft:_isLeft];
    }
}

- (void)removeWithLeft:(BOOL)left
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if (left) // left
        {
            self.center = CGPointMake(- 1000, self.center.y - _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0));

        }
        else // right
        {
            self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0));
        }
        
    } completion:^(BOOL finished)
    {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(cardItemView:didRemoveInTheLeft:)])
    {
        [self.delegate cardItemView:self didRemoveInTheLeft:left];
    }
}


@end
