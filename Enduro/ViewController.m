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

@implementation ViewController

@synthesize barButton, imageView, popoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"init");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Image Picker";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use. 
    
    NSLog(@"Memory Warning!");
}

#pragma mark - View lifecycle

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Your delegate object’s implementation of this method should pass the specified media on to any custom code that needs it, and should then dismiss the picker view.
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    imageView.image = image;
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
    popoverController.popoverContentSize = CGSizeMake(320, 800);
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
    
//    [self listPrivateDocsDir];
    
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
    return YES;
}

@end
