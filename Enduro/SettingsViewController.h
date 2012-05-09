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
#define WHITEBOARD_KEY @"SettingsViewController.Whiteboard"
#define NUMCHANNELS 4
#define DEFAULT_KEY 48 // c3


@interface SettingsViewController : UIViewController <SoundGeneratorDataSource>
@property (nonatomic, readonly) NSArray* channels;
+ (NSString*)noteFromValue:(int)value;

@property (weak, nonatomic) IBOutlet UISwitch *whiteboardMode;
@property (nonatomic, strong) SoundGenerator* soundGenerator;
@end
