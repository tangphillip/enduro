//
//  AudioPlayer.h
//  Enduro
//
//  Created by Apple in its Load Preset Demo.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioPlayer : NSObject <AVAudioSessionDelegate>

- (IBAction) loadPresetOne:(id)sender;
- (IBAction) loadPresetTwo:(id)sender;
- (IBAction) startPlayLowNote:(id)sender;
- (IBAction) stopPlayLowNote:(id)sender;
- (IBAction) startPlayMidNote:(id)sender;
- (IBAction) stopPlayMidNote:(id)sender;
- (IBAction) startPlayHighNote:(id)sender;
- (IBAction) stopPlayHighNote:(id)sender;

@end
