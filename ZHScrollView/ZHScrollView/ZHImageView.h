//
//  ZHImageView.h
//  ZHScrollView
//
//  Created by jay on 15/10/9.
//  Copyright © 2015年 曾辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHImageView : UIImageView

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
-(void)addTarget:(id)target action:(SEL)action;

@end
