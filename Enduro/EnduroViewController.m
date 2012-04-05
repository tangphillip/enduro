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

//- (IBAction)toggleFrozen:(UISwitch*)sender {
//    if(!sender.on) {
//        self.blobs = nil;
//        [self.session startRunning];
//    } else {
//        [self.session stopRunning];
//
//        dispatch_queue_t processQueue = dispatch_queue_create("Process Queue", NULL);
//        dispatch_async(processQueue, ^{
//            
//            NSString *rootPath = [[NSBundle mainBundle] resourcePath];
//            NSString *filePath = [rootPath stringByAppendingPathComponent:@"IMG_0021.jpg"];
//            NSURL *imageURL = [NSURL fileURLWithPath: filePath];
//            NSData* data = [[NSData alloc] initWithContentsOfURL:imageURL];
//            UIImage *image = [UIImage imageWithData:data];
//            
//            NSArray *blobs = [ImageProcessor blobsOfImage: image];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.image = image;
//                self.blobs = blobs; 
//            });
//        });
//        dispatch_release(processQueue);
//    }
//}

- (IBAction)toggleFrozen:(UISwitch*)sender {
    if(!sender.on) {
        self.blobs = nil;
        [self.session startRunning];
    } else {
        [self.session stopRunning];
        
        dispatch_queue_t processQueue = dispatch_queue_create("Process Queue", NULL);
        dispatch_async(processQueue, ^{
            NSArray *blobs = [ImageProcessor blobsOfImage:self.image];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.blobs = blobs; 
            });
        });
        dispatch_release(processQueue);
    }
}

-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
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
