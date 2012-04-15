//
//  ImageCropper.m
//  Enduro
//
//  Created by Phillip Tang on 4/15/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import "ImageProcessor.h"
#import "ImageCropper.h"
#import "CVImageConversion.h"

@implementation ImageCropper

+ (CGImageRef) maskImage:(UIImage *)image withPath:(UIBezierPath *) path {
    
//    CGImageRef maskRef = maskImage.CGImage; 
//    
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
//                                        CGImageGetHeight(maskRef),
//                                        CGImageGetBitsPerComponent(maskRef),
//                                        CGImageGetBitsPerPixel(maskRef),
//                                        CGImageGetBytesPerRow(maskRef),
//                                        CGImageGetDataProvider(maskRef), NULL, false);
//    
//    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
//    return [UIImage imageWithCGImage:masked];


//    [[CIContext contextWithOptions:nil] createCGImage:rotatedImage fromRect:rotatedImage.extent];
    
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, image.size.width * 4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst);

    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    
    CGContextTranslateCTM(context, 0.0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
//    NSLog(@"Bounds = (%f, %f), size: [%f, %f]", path.bounds.origin.x, path.bounds.origin.y, path.bounds.size.width, path.bounds.size.height);
    
    return CGBitmapContextCreateImage(context);
}

+(Pixel) averageColorOfImage: (CGImageRef) image {
    
    IplImage *iplImage = [CVImageConversion IplImageFromUIImage:[UIImage imageWithCGImage:image]];
    
    [ImageProcessor writeImage: iplImage toFile:@"tappedBlob" Grayscale:NO];
    
    IplImage *mask = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 1);
    cvCvtColor(iplImage, mask, CV_BGRA2GRAY);
    cvThreshold(mask, mask, 1, 255, CV_THRESH_BINARY);
    
    CvScalar mean_pixel = cvAvg(iplImage, mask);
    
    Pixel average;
    average.red = mean_pixel.val[0];
    average.green = mean_pixel.val[1];
    average.blue = mean_pixel.val[2];
    
    NSLog(@"Pixel: {red: %f, green: %f, blue: %f, alpha?: %f}", mean_pixel.val[0], mean_pixel.val[1], mean_pixel.val[2], mean_pixel.val[3]);
    return average;
}

+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(currentContext, 0.0, rect.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);   
    
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect( currentContext, clippedRect);
    CGRect drawRect = CGRectMake(rect.origin.x * -1,rect.origin.y * -1,imageToCrop.size.width,imageToCrop.size.height);
    CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cropped;
}

@end
