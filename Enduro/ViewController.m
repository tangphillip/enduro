//
//  ViewController.m
//  Enduro
//
//  Created by Phillip Tang on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "core.hpp"
#import "ImagePicker.h"
#import "blobs.h"

@implementation ViewController

@synthesize barButton, imageView, popoverController, session, videoDevice, videoInput, frameOutput, imgView, faceDetector, context, glasses;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"init");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Image Blob Labeling";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"Memory Warning!");
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use. 
    
}

#pragma mark - View lifecycle

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Your delegate object’s implementation of this method should pass the specified media on to any custom code that needs it, and should then dismiss the picker view.
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    imageView.image = [blobs blobsOfImage:image];
    [imageView sizeToFit];
    [popoverController dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Your delegate’s implementation of this method should dismiss the picker view by calling the dismissModalViewControllerAnimated: method of the parent view controller.
    [popoverController dismissPopoverAnimated:YES];
}

- (IBAction) loadImagePicker:(id)sender {
    ImagePicker *picker = [[ImagePicker alloc] initWithButton:barButton delegate:self];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
    popoverController.popoverContentSize = CGSizeMake(320, 600);
    [popoverController presentPopoverFromBarButtonItem: barButton
                              permittedArrowDirections: UIPopoverArrowDirectionAny
                                              animated: YES ];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View Loaded.");
	// Do any additional setup after loading the view, typically from a nib.
    barButton = [[UIBarButtonItem alloc] initWithTitle: @"Choose Image"
                                                 style: UIBarButtonItemStylePlain
                                                target: self
                                                action: @selector(loadImagePicker:)];
    self.navigationItem.rightBarButtonItem = barButton;
    
//    if (imageView.image == NULL) {
//        [self loadImagePicker:nil];
//    }
    
    
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
    
    self.glasses = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glasses.png"]];
    [self.glasses setHidden:YES];
    [self.view addSubview:self.glasses];
}


-(void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];
        
//    // pass detector the image:
//    NSArray * features = [self.faceDetector featuresInImage:ciImage];
//    bool faceFound = false;
//    for(CIFaceFeature * face in features){
//        if(face.hasLeftEyePosition && face.hasRightEyePosition){
//            CGPoint eyeCenter = CGPointMake(face.leftEyePosition.x*0.5+face.rightEyePosition.x*0.5, face.leftEyePosition.y*0.5+face.rightEyePosition.y*0.5);
//            
//            // set the glasses position based on mouth position
//            double scalex =self.imgView.bounds.size.height/ciImage.extent.size.width;
//            double scaley =self.imgView.bounds.size.width/ciImage.extent.size.height;
//            self.glasses.center = CGPointMake(scaley*eyeCenter.y-self.glasses.bounds.size.height/4.0,scalex*(eyeCenter.x));
//            
//            
//            // set the angle of the glasses using eye deltas
//            double deltax = face.leftEyePosition.x-face.rightEyePosition.x;
//            double deltay = face.leftEyePosition.y-face.rightEyePosition.y;
//            double angle = atan2(deltax, deltay);
//            self.glasses.transform=CGAffineTransformMakeRotation(angle+M_PI);
//            
//            // set size based on distance between the two eyes:
//            double scale = 3.0*sqrt(deltax*deltax+deltay*deltay);
//            self.glasses.bounds = CGRectMake(0, 0, scale, scale);
//            faceFound = true;
//            
//            break;
//        }
//        
//    }
//    
//    if(faceFound){
//        [self.glasses setHidden:NO];
//    }else{
//        [self.glasses setHidden:YES];
//    }
//    
//    // apply hue adjustment filter:
//    
//    CIFilter * filter = [CIFilter filterWithName:@"CIHueAdjust"];
//    [filter setDefaults];
//    [filter setValue:ciImage forKey:@"inputImage"];
//    [filter setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputAngle"];
//    CIImage * result = [filter valueForKey:@"outputImage"];
    
    
    
    CGImageRef ref = [[CIContext contextWithOptions:nil] createCGImage:ciImage fromRect:ciImage.extent];
    imageView.image = [blobs blobsOfImage:[UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight]];
    CGImageRelease(ref);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
