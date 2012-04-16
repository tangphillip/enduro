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
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, image.size.width * 4, colorSpace, kCGImageAlphaNoneSkipFirst);

    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    
    CGContextTranslateCTM(context, 0.0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    CGImageRef maskedImage = CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return maskedImage;
}

+(CvScalar) averageColorOfImage: (CGImageRef) image {
    
    IplImage *iplImage = [CVImageConversion IplImageFromUIImage:[UIImage imageWithCGImage:image]];
    
    [ImageProcessor writeImage: iplImage toFile:@"tappedBlob"];
    NSLog(@"Should NOT be 1: %d", iplImage->nChannels);
    
    IplImage *mask = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 1);
    cvCvtColor(iplImage, mask, CV_BGRA2GRAY);
    cvThreshold(mask, mask, 1, 255, CV_THRESH_BINARY);
    
    CvScalar mean_pixel = cvAvg(iplImage, mask);
    
    cvReleaseImage(&iplImage);
    cvReleaseImage(&mask);
        
    NSLog(@"Pixel: {red: %f, green: %f, blue: %f, alpha?: %f}", mean_pixel.val[0], mean_pixel.val[1], mean_pixel.val[2], mean_pixel.val[3]);
    return mean_pixel;
}

@end
