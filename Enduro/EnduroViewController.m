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
#import "ImageCropper.h"

#import "AppDelegate.h"

# pragma mark - Private Interface

@interface EnduroViewController()

@property (weak, nonatomic) IBOutlet UISwitch *frozen;

@property (nonatomic,strong) AVCaptureSession *session;
@property (strong) AVCaptureDevice *videoDevice;
@property (strong) AVCaptureDeviceInput *videoInput; 
@property (strong) AVCaptureVideoDataOutput *frameOutput; 
@property (nonatomic, weak) IBOutlet EnduroView *enduroView;

@property (nonatomic, strong) AppDelegate* appDelegate;

@end

# pragma mark - Implementation

@implementation EnduroViewController

@synthesize frozen;
@synthesize blobs = _blobs;
@synthesize enduroView = _enduroView;
@synthesize image = _image;
@synthesize appDelegate = _appDelegate;

@synthesize session, videoDevice, videoInput, frameOutput;

- (void)setEnduroView:(EnduroView *)enduroView{
    _enduroView = enduroView;
    [self.enduroView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)]];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTaps:)];
    tapGestureRecognizer.numberOfTouchesRequired = 1;

    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.enduroView addGestureRecognizer:tapGestureRecognizer];
    
    self.enduroView.dataSource = self;
}

#pragma mark - EnduroViewDataSource

#pragma mark Getters/Setters

- (void)setImage:(UIImage*)image {
    _image = image;
    [self.enduroView setNeedsDisplay];
}

- (void)setBlobs:(NSArray *)blobs {
    _blobs = blobs;
    [self.enduroView setNeedsDisplay];
}

- (AppDelegate*)appDelegate{
    if (!_appDelegate) _appDelegate = [[UIApplication sharedApplication]delegate];
    return _appDelegate;
}

#pragma mark Private helpers

- (void)playSound:(UIBezierPath*)path{
    int note = (int)path.bounds.size.width % 100;
    self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90, note, 0x7f);  
}

- (void)stopSound:(UIBezierPath*)path{
    int note = (int)path.bounds.size.width % 100;
    self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90, note, 0x00);      
}

- (UIBezierPath*)pathForTouch:(CGPoint)touch{
    for (UIBezierPath *path in self.blobs) {
        if (CGPathContainsPoint(path.CGPath, NULL, touch, YES)){
            return path;
        }
    }
    return nil;
}

#pragma mark Handlers

- (void)handleTouchBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self.enduroView];
        
        UIBezierPath *path = [self pathForTouch:touchLocation];
        if (path) {
            [self playSound:path];
            CGImageRef croppedImage = [ImageCropper maskImage:self.image withPath:path];
            [ImageCropper averageColorOfImage: croppedImage];
        }
    }
}

- (void)handleTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {        
        CGPoint touchLocation = [touch locationInView:self.enduroView];
        
        UIBezierPath *path = [self pathForTouch:touchLocation];
        if (path) {
            [self stopSound:path];
        }
    }
}

- (void)handleTaps:(UITapGestureRecognizer*)gesture{
    CGPoint touch = [gesture locationInView:self.enduroView];
    UIBezierPath *path = [self pathForTouch:touch];
    if (path){
        [self stopSound:path];
    }
    
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.session = [[AVCaptureSession alloc] init];
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput =[AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];
    
    [self.frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [self.session startRunning];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"Memory Warning!");
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use. 
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

#pragma mark - IBActions

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

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

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
    CIImage *rotatedImage = [ciImage imageByApplyingTransform: [self getDeviceTransformforImage:ciImage]];
    
    CGImageRef ref = [[CIContext contextWithOptions:nil] createCGImage:rotatedImage fromRect:rotatedImage.extent];
    self.image = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
}

@end
