//
//  UIImage+ext.m
//  pp_new
//
//  Created by GaoYong on 15/2/28.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import "UIImage+ext.h"

@implementation UIImage (ext)

/* 拉伸图片 */
+(UIImage *)strenchImageWithImageName:(NSString *)imageName
{
    UIImage *tmpImage = [UIImage imageNamed:imageName];
    UIImage *strenchImage = [tmpImage stretchableImageWithLeftCapWidth:tmpImage.size.width/2 topCapHeight:tmpImage.size.height/2];
    return strenchImage;
}

@end
