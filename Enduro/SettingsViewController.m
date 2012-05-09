//
//  SettingsViewController.m
//  Enduro
//
//  Created by Phillip Tang on 5/8/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "SoundGenerator.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIStepper *channel1Stepper;
@property (weak, nonatomic) IBOutlet UIStepper *channel2Stepper;
@property (weak, nonatomic) IBOutlet UIStepper *channel3Stepper;
@property (weak, nonatomic) IBOutlet UIStepper *channel4Stepper;

@property (weak, nonatomic) IBOutlet UILabel *channel1Description;
@property (weak, nonatomic) IBOutlet UILabel *channel2Description;
@property (weak, nonatomic) IBOutlet UILabel *channel3Description;
@property (weak, nonatomic) IBOutlet UILabel *channel4Description;

@property (readonly, nonatomic) NSArray* channelDescriptions;
@property (readonly, nonatomic) NSArray* channelSteppers;

@property (nonatomic) NSInteger keyNote;
@property (readonly, nonatomic) AppDelegate* appDelegate;
@end

@implementation SettingsViewController
@synthesize channelDescriptions;
@synthesize channelSteppers;
@synthesize channels = _channels;
@synthesize channel1Stepper;
@synthesize channel2Stepper = _channel2Stepper;
@synthesize channel3Stepper = _channel3Stepper;
@synthesize channel4Stepper = _channel4Stepper;
@synthesize channel1Description;
@synthesize channel2Description = _channel2Description;
@synthesize channel3Description = _channel3Description;
@synthesize channel4Description = _channel4Description;
@synthesize keyNote = _keyNote;

#pragma mark - Getters/Setters
- (NSArray*)channelDescriptions{
    return [NSArray arrayWithObjects:
            self.channel1Description,
            self.channel2Description,
            self.channel3Description,
            self.channel4Description, nil];
}

- (NSArray*)channelSteppers{
    return [NSArray arrayWithObjects:
            self.channel1Stepper,
            self.channel2Stepper,
            self.channel3Stepper,
            self.channel4Stepper, nil];
}

- (NSArray*)channels{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *channels = [defaults objectForKey:CHANNELS_KEYS];

    if (!channels){
        channels = [NSMutableArray arrayWithObjects: // inital values
                    [NSNumber numberWithInt:self.channel1Stepper.value], 
                    [NSNumber numberWithInt:self.channel2Stepper.value], 
                    [NSNumber numberWithInt:self.channel3Stepper.value],
                    [NSNumber numberWithInt:self.channel4Stepper.value],
                    nil];
        [defaults setObject:channels forKey:CHANNELS_KEYS];
        [defaults synchronize];   
    }
    return channels;
}

- (NSInteger)keyNote{
    return 60;
}

- (AppDelegate*) appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark - Private Functions

- (void) updateChannel:(int)channel value:(int)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *storedChannels = [[defaults objectForKey:CHANNELS_KEYS] mutableCopy];
    if (!storedChannels) storedChannels = [self.channels mutableCopy];

    [storedChannels replaceObjectAtIndex:channel withObject:[NSNumber numberWithInt:value]];
    self.appDelegate.api->setChannelMessage(self.appDelegate.handle, 0x00, 0xC0 + channel, value, 0x00);
    
    [defaults setObject:storedChannels forKey:CHANNELS_KEYS];
    [defaults synchronize];
}

- (void) updateDescriptionForChannel:(int)channel{
    char name[128];
    int prog = [[self.channels objectAtIndex:channel] intValue];
	self.appDelegate.api->ctrl (self.appDelegate.handle, CRMD_CTRL_GET_INSTRUMENT_NAME + channel, name, sizeof (name));
    
    UILabel* label = [self.channelDescriptions objectAtIndex:channel];
    label.text = [NSString stringWithFormat:@"#%d : %@", prog , [NSString stringWithCString:name encoding:NSASCIIStringEncoding]];

}

- (void) updateStepperForChannel:(int)channel{
    UIStepper* stepper = [self.channelSteppers objectAtIndex:channel];
    stepper.value = [[self.channels objectAtIndex:channel] intValue];
}

#pragma mark - IBActions

- (IBAction)channelChanged:(UIStepper*)sender {
    [self updateChannel:sender.tag value:sender.value];
    [self updateDescriptionForChannel:sender.tag];
}

- (IBAction)playSample:(UIButton*)sender {
    self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90 + sender.tag, self.keyNote, 0x7f);    
}

- (IBAction)stopSample:(UIButton*)sender {
    self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90 + sender.tag, self.keyNote, 0x00);
}

#pragma mark - Lifecycle

- (void)viewDidLoad{
    for (int i=0; i<NUMCHANNELS; i++) {
        [self updateStepperForChannel:i];
        [self updateDescriptionForChannel:i];
    }
}

- (void)viewDidUnload {
    [self setChannel1Stepper:nil];
    [self setChannel2Stepper:nil];
    [self setChannel3Stepper:nil];
    [self setChannel4Stepper:nil];
    [self setChannel1Description:nil];
    [self setChannel2Description:nil];
    [self setChannel3Description:nil];
    [self setChannel4Description:nil];
    [super viewDidUnload];
}

@end
