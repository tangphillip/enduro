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
@synthesize enduroView = _enduroView;
@synthesize image = _image;

@synthesize session, videoDevice, videoInput, frameOutput;

- (void)didReceiveMemoryWarning
{
    NSLog(@"Memory Warning!");
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use. 
}

- (void)setEnduroView:(EnduroView *)enduroView{
    _enduroView = enduroView;
//    [self.enduroView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.enduroView action:@selector(pinch:)]];
//    [self.enduroView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.enduroView action:@selector(pan:)]];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self.enduroView action:@selector(handleTaps:)];
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    
    // The number of taps in order for gesture to be recognized
    tapGestureRecognizer.numberOfTapsRequired = 1;
    NSLog(@"Set taps");
    [self.enduroView addGestureRecognizer:tapGestureRecognizer];
    
    self.enduroView.dataSource = self;
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

-(CGAffineTransform) getDeviceTransformforImage: (CIImage *) image {
    CGFloat xScaleFactor = self.enduroView.bounds.size.height / image.extent.size.width;
    CGFloat yScaleFactor = self.enduroView.bounds.size.width  / image.extent.size.height;

    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
    transform = CGAffineTransformScale(transform, xScaleFactor, yScaleFactor);
    transform = CGAffineTransformTranslate(transform, 0, -image.extent.size.height);
    
    return transform;
}


-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];
    CIImage *rotatedImage = [ciImage imageByApplyingTransform: [self getDeviceTransformforImage: ciImage]];
    
    CGImageRef ref = [[CIContext contextWithOptions:nil] createCGImage:rotatedImage fromRect:rotatedImage.extent];
    self.image = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
}

- (void)viewDidUnload
{
    [self setFrozen:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only allow portrait mode
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

@end
