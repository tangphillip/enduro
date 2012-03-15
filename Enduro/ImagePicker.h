//
//  ImagePicker.h
//  Enduro
//
//  Created by Phillip Tang on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePicker : UIViewController {
    UIImagePickerController *imageController;
    UIBarButtonItem *barButton;
    id<UIImagePickerControllerDelegate, UINavigationControllerDelegate> delegate;
}

@property(retain) IBOutlet UILabel *label;

- (id)init;
- (id)initWithButton: (UIBarButtonItem*) b delegate: (id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) d;

@end
