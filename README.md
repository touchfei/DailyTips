# leanMessage
记录学习笔记
### dispatch_group 日常使用

# dispatch_group 日常使用
**#1.常见书写方式**
`dispatch_group_t group = dispatch_group_create();   
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
      
    });`
    
**#2.如果做的事包含block任务，就需要给没个block任务添加入组与出组的操作**
`dispatch_group_t group = dispatch_group_create();   
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
    });`
    **#3.当我们使用其他的三方库做网络请求或则图片下载时，而请求的任务包含多个，需要
等待这些任务都执行完成之后，再返回结果**，如下列子：


  `dispatch_group_t group = dispatch_group_create();
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
        
    });`




