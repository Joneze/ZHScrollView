//
//  ViewController.m
//  ZHScrollView
//
//  Created by jay on 15/9/30.
//  Copyright © 2015年 曾辉. All rights reserved.
//

#import "ViewController.h"
#import "ZHScrollView.h"

@interface ViewController ()

@property(nonatomic,strong)ZHScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[ZHScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 150)];
    NSArray *array = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    
    _scrollView.slideImagesArray = array;
    _scrollView.ZHScrollViewImageSelectAction = ^(NSInteger i){
        
        NSLog(@"点击了%ld张图片",(long)i);
        
    };
    _scrollView.ZHCurrentIndex = ^(NSInteger index){
        NSLog(@"测试一下：%ld",(long)index);
    };
    _scrollView.PageControlPageIndicatorTintColor = [UIColor colorWithRed:255/255.0f green:244/255.0f blue:227/255.0f alpha:1];
    _scrollView.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0f green:174/255.0f blue:168/255.0f alpha:1];
    _scrollView.autoTime = [NSNumber numberWithFloat:1.0f];
    NSLog(@"%@",_scrollView.slideImagesArray);
    [_scrollView startLoading];
    [self.view addSubview:_scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_scrollView timeStop]; //为了销毁轮播图的timer
}

@end
