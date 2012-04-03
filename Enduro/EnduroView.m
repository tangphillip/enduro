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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    CGContextDrawImage(context, self.bounds, self.dataSource.image.CGImage);
    
    [self.dataSource.image drawInRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, self.bounds.size.width/2, self.bounds.size.height/2);
//    CGContextTranslateCTM(context, 0, -self.bounds.size.height);
    CGContextRotateCTM(context, M_PI_2);
//    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSLog(@"Original Height: %f", self.dataSource.image.size.height);
    NSLog(@"Original Width: %f", self.dataSource.image.size.width);
    NSLog(@"New Height: %f", self.bounds.size.height);
    NSLog(@"New Width: %f", self.bounds.size.width);

    
    CGContextScaleCTM(context, self.bounds.size.height/self.dataSource.image.size.width, self.bounds.size.width/self.dataSource.image.size.height);

//    CGAffineTransformMakeRotation(M_PI_2);

    CGContextTranslateCTM(context, 0, -self.dataSource.image.size.height);

    
    for (UIBezierPath *path in self.dataSource.blobs) {
        [path stroke];
    }
    
    
}

@end
