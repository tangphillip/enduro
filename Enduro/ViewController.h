//
//  ViewController.h
//  Enduro
//
//  Created by Phillip Tang on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property(retain) IBOutlet UIBarButtonItem *barButton;
@property(retain) IBOutlet UIImageView *imageView;
//@property(retain) IBOutlet UINavigationBar *navBar;

- (IBAction) loadImagePicker:(id)sender;

@end
