//
//  ImageProcessor.h
//  Enduro
//
//  Created by Phillip Tang on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageProcessor : NSObject

+(id) blobsOfImage: (UIImage*) image;
+(void) writeImage: (IplImage*) image toFile: (NSString*) filename;

@end
