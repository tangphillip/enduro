//
//  SettingsViewController.h
//  Enduro
//
//  Created by Phillip Tang on 5/8/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundGenerator.h"

#define CHANNELS_KEYS @"SettingsViewController.Channels"
#define NOTE_KEY @"SettingsViewController.Note"
#define NUMCHANNELS 4
#define DEFAULT_KEY 48 // c3


@interface SettingsViewController : UIViewController <SoundGeneratorDataSource>
@property (nonatomic, readonly) NSArray* channels;
@end
