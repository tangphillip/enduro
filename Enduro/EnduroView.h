//
//  EnduroView.h
//  Enduro
//
//  Created by Phillip Tang on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnduroViewDataSource

@property(nonatomic, strong) NSArray *blobs; // An array of UIBezierPaths
@property(nonatomic, strong) UIImage *image;

- (void) handleTouchBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) handleTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface EnduroView : UIView

@property(nonatomic, weak) IBOutlet id<EnduroViewDataSource> dataSource;

@end
