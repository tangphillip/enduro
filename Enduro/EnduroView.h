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

@end

@interface EnduroView : UIView

@property(nonatomic, weak) IBOutlet id<EnduroViewDataSource> dataSource;

@end
