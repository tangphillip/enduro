//
//  ViewController.h
//  Enduro
//
//  Created by Phillip Tang on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EnduroView.h"

@interface EnduroViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, EnduroViewDataSource>

@property(nonatomic, strong) NSArray *blobs;
@property(nonatomic, strong) UIImage *image;

@end
