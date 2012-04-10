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
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextRotateCTM(context, M_PI_2);
    
    CGContextScaleCTM(context, self.bounds.size.height/self.dataSource.image.size.width, self.bounds.size.width/self.dataSource.image.size.height);

    CGContextTranslateCTM(context, 0, -self.dataSource.image.size.height);

//    CGContextScaleCTM(context, self.bounds.size.height/self.dataSource.image.size.height, self.bounds.size.width/self.dataSource.image.size.width);

    for (UIBezierPath *path in self.dataSource.blobs) {
        [path stroke];
    }
}

@end
