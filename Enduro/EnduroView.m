//
//  EnduroView.m
//  Enduro
//
//  Created by Phillip Tang on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnduroView.h"
#import "AppDelegate.h"

@implementation EnduroView

@synthesize dataSource;

#define NOTE 15
- (void)handleTaps:(UITapGestureRecognizer *)gesture{
    NSLog(@"Tap detected");
    CGPoint touch = [gesture locationInView:self];
    for (UIBezierPath *path in self.dataSource.blobs) {
        if (CGPathContainsPoint(path.CGPath, NULL, touch, YES)){
            NSLog(@"Touch detected in blob");
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            int note = (int)path.bounds.size.width % 100;
//            NSLog(@"%f", [path bounds].size.width);
            appDelegate.api->setChannelMessage (appDelegate.handle, 0x00, 0x90, note, 0x7F);
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
