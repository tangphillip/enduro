//
//  ViewController.m
//  Enduro
//
//  Created by Phillip Tang on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnduroViewController.h"
#import "core.hpp"
#import "ImageProcessor.h"

@interface EnduroViewController()

@property (weak, nonatomic) IBOutlet UISwitch *frozen;

@property (nonatomic,strong) AVCaptureSession *session;
@property (strong) AVCaptureDevice *videoDevice;
@property (strong) AVCaptureDeviceInput *videoInput; 
@property (strong) AVCaptureVideoDataOutput *frameOutput; 
@property (nonatomic, weak) IBOutlet EnduroView *enduroView;

@end

@implementation EnduroViewController

@synthesize frozen;
@synthesize blobs = _blobs;
@synthesize enduroView;
@synthesize image = _image;

@synthesize session, videoDevice, videoInput, frameOutput;

- (void)didReceiveMemoryWarning
{
    NSLog(@"Memory Warning!");
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use. 
}

#pragma mark - EnduroViewDataSource

- (void)setImage:(UIImage*)image {
    _image = image;
    [self.enduroView setNeedsDisplay];
}

- (void)setBlobs:(NSArray *)blobs {
    _blobs = blobs;
    [self.enduroView setNeedsDisplay];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
//    self.enduroView.dataSource = self;
    
    self.session = [[AVCaptureSession alloc] init];
//    self.session.sessionPreset = AVCaptureSessionPresetLow;
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput =[AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];
    
    [self.frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [self.session startRunning];
}

- (IBAction)toggleFrozen:(UISwitch*)sender {
    if(!sender.on) {
        self.blobs = nil;
        [self.session startRunning];
    }
}

-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if(frozen.on) {
        self.blobs = [ImageProcessor blobsOfImage:self.image];
        [self.session stopRunning];
        return;
    };
    
    CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];

    CGImageRef ref = [[CIContext contextWithOptions:nil] createCGImage:ciImage fromRect:ciImage.extent];
    self.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(ref);

}

- (void)viewDidUnload
{
    [self setFrozen:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIDeviceOrientationPortrait) return YES;
    return NO;
}

@end
