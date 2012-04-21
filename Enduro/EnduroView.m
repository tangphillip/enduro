//
//  ;
//  Enduro
//
//  Created by Phillip Tang on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnduroView.h"
#import "AppDelegate.h"
#import "ImageCropper.h"

@interface EnduroView()

@end

@implementation EnduroView

@synthesize dataSource;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.dataSource handleTouchBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.dataSource handleTouchEnded:touches withEvent:event];   
}

- (void)drawRect:(CGRect)rect
{    
    [self.dataSource.image drawInRect:rect];
    
    [[UIColor redColor] setStroke];
    
    for (UIBezierPath *path in self.dataSource.blobs) {
        [path stroke];
    }
}

@end
