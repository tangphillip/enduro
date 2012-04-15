//
//  ImageCropper.h
//  Enduro
//
//  Created by Phillip Tang on 4/15/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _Pixel {
    int red;
    int green;
    int blue;
} Pixel;

@interface ImageCropper : NSObject

+ (CGImageRef) maskImage:(UIImage *)image withPath:(UIBezierPath *) path;
+(Pixel) averageColorOfImage: (CGImageRef) image;

@end
