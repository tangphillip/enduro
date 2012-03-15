//
//  ViewController.h
//  Enduro
//
//  Created by Phillip Tang on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(strong, nonatomic, retain) IBOutlet UIBarButtonItem *barButton;
@property(strong, nonatomic, retain) IBOutlet UIImageView *imageView;
@property(strong, nonatomic, retain) IBOutlet UIPopoverController *popoverController;
//@property(retain) IBOutlet UINavigationBar *navBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (IBAction) loadImagePicker:(id)sender;

@end
