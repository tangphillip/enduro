//
//  ImageCropper.h
//  Enduro
//
//  Created by Phillip Tang on 4/15/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCropper : NSObject

+ (CGImageRef) maskImage:(UIImage *)image withPath:(UIBezierPath *) path;
+ (CvScalar) averageColorOfImage: (CGImageRef) image;

@end
