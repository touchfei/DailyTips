# leanMessage
记录学习笔记


## dispatch_group 日常使用


**#1.常见书写方式**


```
dispatch_group_t group = dispatch_group_create();   
dispatch_queue_t queue = dispatch_queue_create("com.formssi.get_product_detail", NULL);
dispatch_group_async(group,queue, ^{
         <!--do work-->
    });
dispatch_group_async(group,queue, ^{
         <!--do work-->
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
     <!--main thread-->
     <!--do work-->
      
    });
```
    
**#2.如果做的事包含block任务，就需要给没个block任务添加入组与出组的操作**

```
dispatch_group_t group = dispatch_group_create();   
dispatch_queue_t queue = dispatch_queue_create("com.baidu.detail", NULL);
dispatch_group_enter(group);
dispatch_group_async(group,queue, ^{
         <!--do block work-->
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
dispatch_group_async(group,queue, ^{
         <!--do block work-->
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      <!--main thread-->
      <!--do work-->
    });
```

**#3.当我们使用其他的三方库做网络请求或则图片下载时，而请求的任务包含多个，需要
等待这些任务都执行完成之后，再返回结果**，如下列子：


```

dispatch_group_t group = dispatch_group_create();

    __block BOOL isSuccess = NO;
    for (CellModel *cellModel in modelArray) {
         <!--异步下载图片-->
        dispatch_group_enter(group);
        [[SDWebImageManager sharedManager] downloadImageWithURL:cellModel.url options:SDWebImageRetryFailed | SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            NSLog(@"downloadError = %@-%@",error,[NSThread currentThread]);
            if (error) {
                isSuccess = NO;
            }else{
                isSuccess = YES;
                <!-- 获取图片大小-->
                cellModel.cellHeight = WidthOfWindow * image.size.height / image.size.width;
            }
            dispatch_group_leave(group);
        }];
    }
    

dispatch_group_notify(group, dispatch_get_main_queue(), ^{
         <!-- more -->
        if (isSuccess) {
            completion(NetWorkingResultTypeSuccess,@"success");
        }else{
            completion(NetWorkingResultTypeNoData, @"error");
        }
        
    });

```

##侧滑返回手势

自定定义返回按钮时，系统自带的滑动返回手势会失效：
新建一个类，继承UINavigationController，重写pushViewController: animated: 方法，如下：

```
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        // 影藏TabBar
        viewController.hidesBottomBarWhenPushed = YES;
        // 自定义返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    }
    
    [super pushViewController:viewController animated:animated];
}
```
解决方式一：

```
- (void)viewDidLoad {
    [super viewDidLoad];
    // 返回手势的代理
    self.interactivePopGestureRecognizer.delegate = self;
}

// 实现代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 非根控制器才接受手势
    BOOL result = self.childViewControllers.count > 1;
    return result;
    
}

```
方式二：

```
@interface RootNavigationController ()<UINavigationControllerDelegate>
{
    id _popDelegate;
}

@end

@implementation RootNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 记录滑动代理的的值
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}
@end


//代理方法 导航控制器跳转完成的时候调用
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.viewControllers.firstObject) {//显示根控制器
        //还原滑动手势的代理
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
        
    }else{//不是根控制器
        //实现滑动返回功能
        //清空滑动返回手势的代理，就能实现滑动功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

```


