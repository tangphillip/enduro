//
//  SoundGenerator.h
//  Enduro
//
//  Created by Benjamin Koltai on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundGenerator : NSObject
- (NSString*)playSoundForPath:(UIBezierPath*)path inImage:(UIImage*)image;
- (NSString*)stopSoundForPath:(UIBezierPath*)path inImage:(UIImage*)image;

- (void) precalculateChords: (NSArray *) blobs image: (UIImage*) image;
-(void)clearCache;
@end
