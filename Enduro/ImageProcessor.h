//
//  ImageProcessor.h
//  Enduro
//
//  Created by Phillip Tang on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageProcessor : NSObject

+(NSArray*) blobsOfImage: (UIImage*) image scaleFactor: (CGFloat) factor;
+(void) writeImage: (IplImage*) image toFile: (NSString*) filename;
+ (NSArray*) contoursOfImage: (UIImage *) image scaleFactor: (CGFloat) factor;

@end
