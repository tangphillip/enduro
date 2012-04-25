//
//  ImageCropper.h
//  Enduro
//
//  Created by Phillip Tang on 4/15/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

typedef struct{
    double red;
    double green;
    double blue;
    double alpha;
}RGBAPixel;

#import <Foundation/Foundation.h>

@interface ImageCropper : NSObject
+ (RGBAPixel) averageColorOfPath:(UIBezierPath*)path inImage:(UIImage*)image;
/*
 typedef struct CvScalar
 {
    double val[4];
 }
 CvScalar;
 */
@end
