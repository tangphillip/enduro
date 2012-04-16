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

@interface EnduroViewController()

@property (weak, nonatomic) IBOutlet UISwitch *frozen;

@property (nonatomic,strong) AVCaptureSession *session;
@property (strong) AVCaptureDevice *videoDevice;
@property (strong) AVCaptureDeviceInput *videoInput; 
@property (strong) AVCaptureVideoDataOutput *frameOutput; 
@property (nonatomic, weak) IBOutlet EnduroView *enduroView;

@property (nonatomic, strong) AppDelegate* appDelegate;

@end

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
    //    
    //    UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self.enduroView action:@selector(handleLong:)];
    //    longGestureRecognizer.numberOfTouchesRequired = 2;
    //    longGestureRecognizer.numberOfTapsRequired = 1;
    //    longGestureRecognizer.minimumPressDuration = 0.5;
    //    longGestureRecognizer.allowableMovement = 2.0;
    //    
    //    // The number of taps in order for gesture to be recognized
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.enduroView addGestureRecognizer:tapGestureRecognizer];
    //    [self.enduroView addGestureRecognizer:longGestureRecognizer];
    
    self.enduroView.dataSource = self;
}

#pragma mark - EnduroViewDataSource

- (void)playSound:(UIBezierPath*)path{
    int note = (int)path.bounds.size.width % 100;
    self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90, note, 0x7f);  
}

- (void)stopSound:(UIBezierPath*)path{
    int note = (int)path.bounds.size.width % 100;
    self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90, note, 0x00);      
}

- (AppDelegate*)appDelegate{
    if (!_appDelegate) _appDelegate = [[UIApplication sharedApplication]delegate];
    return _appDelegate;
}

- (void)setImage:(UIImage*)image {
    _image = image;
    [self.enduroView setNeedsDisplay];
}

// multi touch start/stop notes

- (void)setBlobs:(NSArray *)blobs {
    _blobs = blobs;
    [self.enduroView setNeedsDisplay];
}

- (UIBezierPath*)pathForTouch:(CGPoint)touch{
    for (UIBezierPath *path in self.blobs) {
        if (CGPathContainsPoint(path.CGPath, NULL, touch, YES)){
            return path;
        }
    }
    return nil;
}

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

- (void)handleSwipe:(UISwipeGestureRecognizer*)gesture{
    CGPoint touch = [gesture locationInView:self.enduroView];
    UIBezierPath *path = [self pathForTouch:touch];
    if (path) {
        // NOTE: Swipping right is only swipe recognized. Investigate this!
//        if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
//            [self playSound:path];
            //        }else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft){
            //            [self stopSound:path];
//        }
    }
}

- (void)handleTaps:(UITapGestureRecognizer*)gesture{
//    CGPoint touch = [gesture locationInView:self.enduroView];
//    UIBezierPath *path = [self pathForTouch:touch];
    
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

-(CGAffineTransform) getDeviceTransformforImage: (CIImage *) image {
    CGFloat xScaleFactor = self.enduroView.bounds.size.height / image.extent.size.width;
    CGFloat yScaleFactor = self.enduroView.bounds.size.width  / image.extent.size.height;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
    transform = CGAffineTransformScale(transform, xScaleFactor, yScaleFactor);
    transform = CGAffineTransformTranslate(transform, 0, -image.extent.size.height);
    
    return transform;
}

- (IBAction)showPlayer:(id)sender {
//    [self performSegueWithIdentifier:@"Show Player" sender:self];
}

-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sampleBuffer);

    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];
    CIImage *rotatedImage = [ciImage imageByApplyingTransform: [self getDeviceTransformforImage: ciImage]];
    
    CGImageRef ref = [[CIContext contextWithOptions:nil] createCGImage:rotatedImage fromRect:rotatedImage.extent];
    CGImageRelease(self.image.CGImage);
    self.image = [UIImage imageWithCGImage:ref];
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
