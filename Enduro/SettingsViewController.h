//
//  SettingsViewController.h
//  Enduro
//
//  Created by Phillip Tang on 5/8/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundGenerator.h"

@interface SettingsViewController : UIViewController <SoundGeneratorDataSource>
@property (nonatomic, strong) NSArray* channels;
@end
