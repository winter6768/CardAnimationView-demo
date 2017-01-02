//
//  ViewController.m
//  CardAnimationView-demo
//
//  Created by 杨艳东 on 2016/12/29.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "ViewController.h"
#import "CardAnimationView.h"

@interface ViewController ()<CardAnimationViewDelegate,CardAnimationViewDataSource>
{
    CardAnimationView *view_card;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    view_card = [[CardAnimationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 550)];
    view_card.backgroundColor = [UIColor darkGrayColor];
    view_card.cardItemSize = CGSizeMake(self.view.frame.size.width - 30, self.view.frame.size.width + 50);
    view_card.delegate = self;
    view_card.dataSource = self;
    [self.view addSubview:view_card];
    
    [view_card reloadData];
    
    
    UIButton *btn_left = [UIButton new];
    [btn_left setTitle:@"左滑" forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    btn_left.frame = CGRectMake(10, 560, 150, 50);
    btn_left.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:btn_left];
    
    UIButton *btn_right = [UIButton new];
    [btn_right setTitle:@"右滑" forState:UIControlStateNormal];
    [btn_right addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    btn_right.frame = CGRectMake(self.view.frame.size.width - 160, 560, 150, 50);
    btn_right.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:btn_right];
}

-(NSInteger)numberOfItemViewsInCardView:(CardAnimationView *)cardAnimationView
{
    return 10;
}

-(CardItemView *)cardAnimationView:(CardAnimationView *)cardAnimationView itemViewAtIndex:(NSInteger)index
{
    CardItemView *item = [CardItemView new];

    return item;
}

-(void)cardAnimationViewNeedMoreData:(CardAnimationView *)cardAnimationView
{
    NSLog(@"need more data");
    [view_card reloadData];
}

-(void)cardAnimationView:(CardAnimationView *)cardAnimationView didDisappearInTheLeft:(BOOL)isLeft
{
    
}

-(void)buttonTap:(UIButton *)button
{
    [view_card removeTopItemInTheLeft: [button.currentTitle isEqualToString:@"左滑"]];
}

@end
