# ZHScrollView
###banner for IOS
效果图

![效果图](https://github.com/Joneze/ZHScrollView/blob/master/ZHScrollView/image/H5GIF2.gif)


在我自己的项目上的实际应用

![image](https://github.com/Joneze/ZHScrollView/blob/master/ZHScrollView/image/H5GIF.gif)

###图片轮播 Banner
* 使用简单
* 实现了定时轮播功能，可自定义各项功能
* 实现了点击效果

###如何使用ZHScrollView

* 手动导入
* 将项目文件夹中的ZHScrollView文件夹加入到项目中
* 如果项目中用导航push到下级页面，然后使用了本组件会出现图片偏移，需加入此句代码

    self.automaticallyAdjustsScrollViewInsets = NO;

###使用方法
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHScrollView *testView = [[ZHScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200)];
    NSArray *imageArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    testView.slideImagesArray = imageArray;
    testView.ianEcrollViewSelectAction = ^(NSInteger i)
    {
         NSLog(@"点击了%ld张图片",(long)i);
    };
    
    testView.ianCurrentIndex = ^(NSInteger index){
        NSLog(@"测试一下：%ld",(long)index);
    };
    
    [testView starLoading];
    [self.view addSubview:testView];
}
```
具体使用参考demo

##提醒
工程的创建使用了Xcode7版本

##期望
如果在使用过程中遇到BUG，希望你能联系我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
如果在使用过程中发现功能不够用，希望你能联系我，我非常想为这个控件增加更多好用的功能，谢谢
