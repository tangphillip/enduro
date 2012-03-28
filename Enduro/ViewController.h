//
//  ViewController.h
//  Enduro
//
//  Created by Phillip Tang on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property(strong, nonatomic, retain) IBOutlet UIBarButtonItem *barButton;
@property(strong, nonatomic, retain) IBOutlet UIImageView *imageView;
@property(strong, nonatomic, retain) IBOutlet UIPopoverController *popoverController;
//@property(retain) IBOutlet UINavigationBar *navBar;

@property (nonatomic,strong) AVCaptureSession *session;
@property (strong) AVCaptureDevice *videoDevice;
@property (strong) AVCaptureDeviceInput *videoInput; 
@property (strong) AVCaptureVideoDataOutput *frameOutput; 
@property (nonatomic,strong) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) CIDetector *faceDetector;
@property (nonatomic,strong) CIContext *context;
@property (nonatomic,strong) UIImageView *glasses;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (IBAction) loadImagePicker:(id)sender;

@end
