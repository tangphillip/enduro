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
#import "SoundGenerator.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"

# pragma mark - Private Interface

@interface EnduroViewController()

@property BOOL frozen;
@property (weak, nonatomic) IBOutlet UIButton *shutterButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *throbber;
@property (weak, nonatomic) IBOutlet UIImageView *throbberBackground;

@property (strong, nonatomic) UIStoryboardPopoverSegue* popSegue;
@property (weak) UIPopoverController *settingsPopover;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *chordLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (nonatomic,strong) AVCaptureSession *session;
@property (strong) AVCaptureDevice *videoDevice;
@property (strong) AVCaptureDeviceInput *videoInput; 
@property (strong) AVCaptureVideoDataOutput *frameOutput; 
@property (nonatomic, weak) IBOutlet EnduroView *enduroView;
@property (nonatomic, strong) SoundGenerator *soundGenerator;

@property (nonatomic, strong) AppDelegate* appDelegate;
@property (nonatomic, strong) SettingsViewController* settingsController;

@end

# pragma mark - Implementation

@implementation EnduroViewController

@synthesize settingsPopover;
@synthesize settingsController = _settingsController;

- (IBAction)showPopover:(id)sender {
    if (settingsPopover) 
        [settingsPopover dismissPopoverAnimated:YES];
    else
        [self performSegueWithIdentifier:@"popover" sender:sender];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [[segue identifier] isEqualToString:@"popover"] )
    {
        //[[segue destinationViewController] setDelegate:self];
        NSLog(@"%@",[[segue destinationViewController] viewControllers]);
        self.popSegue = (UIStoryboardPopoverSegue*)segue;
    }
    NSLog(@"Segue.");
}

@synthesize soundGenerator;
@synthesize frozen;
@synthesize shutterButton;
@synthesize resetButton;
@synthesize throbber;
@synthesize throbberBackground;
@synthesize chordLabel;
@synthesize settingsButton;
@synthesize blobs = _blobs;
@synthesize enduroView = _enduroView;
@synthesize image = _image;
@synthesize appDelegate = _appDelegate;
@synthesize popSegue;

@synthesize session, videoDevice, videoInput, frameOutput;

- (void)setEnduroView:(EnduroView *)enduroView{
    _enduroView = enduroView;
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

    self.throbberBackground.hidden = YES;
    [self.throbber stopAnimating];
    
    if(blobs) {
        [self.soundGenerator precalculateChords:blobs image: self.image];
    } else {
        [self.soundGenerator clearCache];
    }

    [self.enduroView setNeedsDisplay];
}

- (AppDelegate*)appDelegate{
    if (!_appDelegate) _appDelegate = [[UIApplication sharedApplication]delegate];
    return _appDelegate;
}

#pragma mark Private helpers

- (void)playSound:(UIBezierPath*)path{
    NSString* chordName = [self.soundGenerator playSoundForPath:path inImage:self.image];
    self.chordLabel.title = chordName;
}

- (void)stopSound:(UIBezierPath*)path{
    [self.soundGenerator stopSoundForPath:path inImage:self.image];
}

- (UIBezierPath*)pathForTouch:(CGPoint)touch{
    for (UIBezierPath *path in self.blobs) {
        if (CGPathContainsPoint(path.CGPath, NULL, touch, YES)){
            return path;
        }
    }
    return nil;
}
- (IBAction)test:(id)sender {
    NSLog(@"derp");
}

#pragma mark Handlers

- (void)handleTouchBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self.enduroView];
        
        UIBezierPath *path = [self pathForTouch:touchLocation];
        if (path) {
            [self playSound:path];
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
    
    settingsButton.action = @selector(showPopover:);
    
    self.frozen = NO;
    self.session = [[AVCaptureSession alloc] init];
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput =[AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];
    
    [self.frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [self.session startRunning];
    self.soundGenerator = [[SoundGenerator alloc] init];
    
    self.chordLabel.title = nil;
    self.settingsController = [[SettingsViewController alloc] init];
    self.soundGenerator.dataSource = self.settingsController;
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"Memory Warning!");
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use. 
}

- (void)viewDidUnload
{
    [self setShutterButton:nil];
    [self setResetButton:nil];
    [self setThrobber:nil];
    [self setThrobberBackground:nil];
    [self setChordLabel:nil];
    [self setSettingsButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only allow portrait mode
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

#pragma mark - IBActions

- (IBAction)toggleFrozen:(UIButton*)sender {
    if(self.frozen) {
        self.frozen = NO;
        self.blobs = nil;
        self.shutterButton.hidden = NO;
        self.resetButton.hidden = YES;
        self.throbberBackground.hidden = YES;
        [self.throbber stopAnimating];
        [self.session startRunning];
    } else {
        self.frozen = YES;
        self.shutterButton.hidden = YES;
        self.resetButton.hidden = NO;
        [self.session stopRunning];
        self.throbberBackground.hidden = NO;
        [self.throbber startAnimating];
        
        dispatch_queue_t processQueue = dispatch_queue_create("Process Queue", NULL);
        dispatch_async(processQueue, ^{
            NSArray *blobs = [ImageProcessor blobsOfImage:self.image scaleFactor:self.view.contentScaleFactor];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.blobs = blobs;
            });
        });
        dispatch_release(processQueue);
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

-(CGAffineTransform) getDeviceTransformforImage: (CIImage *) image {
    CGFloat xScaleFactor = self.enduroView.bounds.size.height * self.view.contentScaleFactor / image.extent.size.width;
    CGFloat yScaleFactor = self.enduroView.bounds.size.width  * self.view.contentScaleFactor / image.extent.size.height;
    
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
