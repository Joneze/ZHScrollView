//
//  ZHScrollView.h
//  ZHScrollView
//
//  Created by jay on 15/10/9.
//  Copyright © 2015年 曾辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZHScrollViewSelectBlock)(NSInteger);
typedef void (^ZHScrollViewCurrentIndex)(NSInteger);

@interface ZHScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, copy  ) NSArray                   *slideImagesArray;                   // 存储图片的地址
@property (nonatomic, copy  ) ZHScrollViewSelectBlock  ZHScrollViewImageSelectAction;       // 图片点击事件
@property (nonatomic, copy  ) ZHScrollViewCurrentIndex ZHCurrentIndex;                      // 此时的幻灯片图片序号
@property (nonatomic        ) BOOL                     withoutPageControl;                  // 是否显示pageControl
@property (nonatomic        ) BOOL                     withoutAutoScroll;                   // 是否自动滚动
@property (nonatomic        ) NSNumber                 *autoTime;                           // 滚动时间
@property (nonatomic, strong) UIColor                  *pageControlCurrentPageIndicatorTintColor;   //圆点的颜色
@property (nonatomic, strong) UIColor                  *PageControlPageIndicatorTintColor;
   

- (void)startLoading;                           // 加载初始化（必须实现）
// 或者
- (void)startLoadingByIndex:(NSInteger)index;   // 加载初始化并制定初始图片

-(void)timeStop; //如果页面需销毁必须实现此方法

@end
