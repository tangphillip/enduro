//
//  EnduroView.m
//  Enduro
//
//  Created by Phillip Tang on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnduroView.h"

@implementation EnduroView

@synthesize dataSource;

- (void)handleTaps:(UITapGestureRecognizer *)gesture{
    NSLog(@"Tap detected");
    CGPoint touch = [gesture locationInView:self];
    for (UIBezierPath *path in self.dataSource.blobs) {
        if (CGPathContainsPoint(path.CGPath, NULL, touch, YES)){
            NSLog(@"Touch detected in blob");
        }

    }
}

- (void)drawRect:(CGRect)rect
{    
    [self.dataSource.image drawInRect:rect];
    
    for (UIBezierPath *path in self.dataSource.blobs) {
        [path stroke];
    }
}

@end
