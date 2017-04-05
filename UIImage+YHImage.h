//
//  UIImage+YHImage.h
//  YouHuJournery
//
//  Created by GaoFei on 8/3/16.
//  Copyright © 2016 yoohooo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YHImage)


-(UIImage *)addText:(UIImage *)img text:(NSString *)text1;
-(UIImage *)imageFromText:(NSString *)text;

- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

@end
