//
//  ZHScrollView.m
//  ZHScrollView
//
//  Created by jay on 15/10/9.
//  Copyright © 2015年 曾辉. All rights reserved.
//

#import "ZHScrollView.h"
#import "ZHImageView.h"

@interface ZHScrollView ()

{
    NSInteger _tempPage;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *myTimer;

@end



@implementation ZHScrollView

//懒加载加载scrollView
-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.userInteractionEnabled = YES;
        [self addSubview:_scrollView];
        
        //取消弹簧效果
        _scrollView.bounces = YES;
        
        //取消滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;//水平
        _scrollView.showsVerticalScrollIndicator = NO;//竖直
        
        //要分页
        _scrollView.pagingEnabled = YES;
        
        //设置代理
        _scrollView.delegate = self;
        
        if(self.slideImagesArray.count < 2){
            _scrollView.scrollEnabled = NO;
        }
        
        
    }
    return _scrollView;
}

-(UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        //分页控件，本质上和scrollView没有任何关系，是两个独立的控件
        _pageControl = [[UIPageControl alloc]init];
        
        //总页数
        _pageControl.numberOfPages = self.slideImagesArray.count;
        _pageControl.frame = CGRectMake((self.scrollView.frame.size.width-100)/2,self.scrollView.frame.size.height-18 , 100, 15);
        _pageControl.currentPage = 0;
        //设置颜色
        _pageControl.pageIndicatorTintColor = self.PageControlPageIndicatorTintColor ? self.PageControlPageIndicatorTintColor : [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = self.pageControlCurrentPageIndicatorTintColor ? self.pageControlCurrentPageIndicatorTintColor : [UIColor purpleColor];
        
        [self addSubview:_pageControl];
        
        //添加监听方法
        /**在OC中，绝大多数“继承UIControl控件”，都可以监听UIControlEventValueChanged事件，只有button除外，button是点得，是touchup。。。*/
//        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)startLoading
{
    [self initScrollView];
}

- (void)startLoadingByIndex:(NSInteger)index
{
    [self startLoading];
    _tempPage = index;
    [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * (index + 1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}

#pragma mark -private Methods-
-(void)initScrollView
{
    if (_scrollView) {
        return;
    }
    
    for (NSInteger i = 0; i < _slideImagesArray.count; i++) {
        ZHImageView *slideImage = [[ZHImageView alloc] init];
        slideImage.contentMode = UIViewContentModeScaleToFill;
        slideImage.image = [UIImage imageNamed:_slideImagesArray[i]];
        slideImage.tag = i;
        slideImage.frame = CGRectMake(self.scrollView.frame.size.width * i + self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [slideImage addTarget:self action:@selector(ImageClick:)]; 
        [self.scrollView addSubview:slideImage];// 首页是第0页,默认从第1页开始的。所以+_scrollView.frame.size.width
    }
    
    // 取数组最后一张图片 放在第0页
    ZHImageView *firstSlideImage = [[ZHImageView alloc] init];
    firstSlideImage.contentMode = UIViewContentModeScaleToFill;
    [firstSlideImage setImage:[UIImage imageNamed:_slideImagesArray[_slideImagesArray.count - 1]]];
    firstSlideImage.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self.scrollView addSubview:firstSlideImage];
    
    // 取数组的第一张图片 放在最后1页
    ZHImageView *endSlideImage = [[ZHImageView alloc] init];
    endSlideImage.contentMode = UIViewContentModeScaleToFill;
    [endSlideImage setImage:[UIImage imageNamed:_slideImagesArray[0]]];
    endSlideImage.frame = CGRectMake((_slideImagesArray.count + 1) * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self.scrollView addSubview:endSlideImage];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * (_slideImagesArray.count + 2), self.scrollView.frame.size.height)]; //+上第1页和第4页  原理：4-[1-2-3-4]-1
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    
    if (!self.withoutAutoScroll) {
        if (!self.autoTime) {
            self.autoTime = [NSNumber numberWithFloat:2.0f];
        }
        _myTimer = [NSTimer timerWithTimeInterval:[self.autoTime floatValue] target:self selector:@selector(runTimePage)userInfo:nil repeats:YES];
        
        [[NSRunLoop  currentRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark -scrollView Delegate-
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWith = self.scrollView.frame.size.width;
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWith/([_slideImagesArray count]+2))/pageWith) + 1;
    page --; //默认从第二页开始
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWith = self.scrollView.frame.size.width;
    NSInteger currentPage = floor((self.scrollView.contentOffset.x - pageWith/ ([_slideImagesArray count]+2)) / pageWith) + 1;
    NSLog(@"当前页%ld",(long)currentPage);
    if (currentPage == 0) {
        if (self.ZHCurrentIndex) {
            self.ZHCurrentIndex(_slideImagesArray.count-1);
        }
        [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * _slideImagesArray.count, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    }else if(currentPage == _slideImagesArray.count + 1){
        if (self.ZHCurrentIndex){
            self.ZHCurrentIndex(0);
        }
        [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO
         ];
    }else{
        if (self.ZHCurrentIndex){
            self.ZHCurrentIndex(currentPage-1);
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.withoutAutoScroll){
        if (_tempPage == 0) {
            [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * _slideImagesArray.count, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
        }else if(_tempPage == _slideImagesArray.count){
            [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width,_scrollView.frame.size.height) animated:NO
             ];
        }
    }
}

#pragma mark -PageControl Method-
- (void)turnPage:(NSInteger)page
{
    _tempPage = page;
    [self.scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * (page + 1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}

#pragma mark -定时器 Method-
- (void)runTimePage
{
    NSInteger page = self.pageControl.currentPage;
    page ++;
    [self turnPage:page];
}

- (void)ImageClick:(UIImageView *)sender
{
    if (self.ZHScrollViewImageSelectAction) {
        self.ZHScrollViewImageSelectAction(sender.tag);
    }
}

-(void)timeStop
{
    [_myTimer invalidate];
}

@end
