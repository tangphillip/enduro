//
//  SoundGenerator.h
//  Enduro
//
//  Created by Benjamin Koltai on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SoundGeneratorDataSource
@property (nonatomic, strong) NSArray* channels;
@end

@interface SoundGenerator : NSObject

@property(nonatomic, weak) IBOutlet id<SoundGeneratorDataSource> dataSource;

- (NSString*)playSoundForPath:(UIBezierPath*)path inImage:(UIImage*)image;
- (NSString*)stopSoundForPath:(UIBezierPath*)path inImage:(UIImage*)image;

- (void) precalculateChords: (NSArray *) blobs image: (UIImage*) image;
- (void)clearCache;
@end
