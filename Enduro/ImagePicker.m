//
//  ImagePicker.m
//  Enduro
//
//  Created by Phillip Tang on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImagePicker.h"

#import <MobileCoreServices/UTCoreTypes.h>

@implementation ImagePicker

@synthesize label;

-(id) init {
    return [super init];
}

- initWithButton: (UIBarButtonItem*) b delegate: (id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) d
{
    self = [super init];
    
    if (self) {
        barButton = b;
        delegate = d;
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Popover View Loaded.");
	// Do any additional setup after loading the view, typically from a nib.

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"%@", [[UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary] description]);
        
        imageController = [[UIImagePickerController alloc] init];
        imageController.delegate = delegate;
        //            imageController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:self];
        popover.popoverContentSize = CGSizeMake(600, 800);
        [popover presentPopoverFromBarButtonItem: barButton
                        permittedArrowDirections: UIPopoverArrowDirectionAny
                                        animated: YES ];
        
        //            [view presentViewController:imageController animated:YES completion:NULL];
    }

    
    //    [self listPrivateDocsDir];
    
}

@end
