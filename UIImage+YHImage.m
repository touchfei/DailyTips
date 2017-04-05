//
//  UIImage+YHImage.m
//  YouHuJournery
//
//  Created by GaoFei on 8/3/16.
//  Copyright © 2016 yoohooo. All rights reserved.
//

#import "UIImage+YHImage.h"

@implementation UIImage (YHImage)


-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //上下文的大小
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//创建颜色
    //创建上下文
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 44 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);//将img绘至context上下文中
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);//设置颜色
    char* text = [text1 cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Georgia", 12, kCGEncodingMacRoman);//设置字体的大小
    CGContextSetTextDrawingMode(context, kCGTextFill);//设置字体绘制方式
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);//设置字体绘制的颜色
    CGContextSetLineWidth(context, 2);
//    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextShowTextAtPoint(context, w/2-strlen(text)*3, h/2-1, text, strlen(text));//设置字体绘制的位置
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);//创建CGImage
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];//获得添加水印后的图片
}


-(UIImage *)imageFromText:(NSString *)text{
    UIFont *font = [UIFont systemFontOfSize:20.0];
    
    CGSize size  = [text sizeWithFont:font];
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // optional: add a shadow
    // optional: also, to avoid clipping you should make the context size bigger     CGContextSetShadowWithColor(ctx, CGSizeMake(2.0, -2.0), 5.0, [[UIColor grayColor] CGColor]);
    // draw in context
    [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}





- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
