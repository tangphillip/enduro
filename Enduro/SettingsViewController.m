//
//  SettingsViewController.m
//  Enduro
//
//  Created by Phillip Tang on 5/8/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"

char notes[12][2] = {
    "a",
    "b",//flat
    "b",
    "c",
    "c",//sharp
    "d",
    "e",//flat
    "e",
    "f",
    "f",//sharp
    "g",
    "a",//flat
};
@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIStepper *channel1Stepper;
@property (weak, nonatomic) IBOutlet UIStepper *channel2Stepper;
@property (weak, nonatomic) IBOutlet UIStepper *channel3Stepper;
@property (weak, nonatomic) IBOutlet UIStepper *channel4Stepper;

@property (weak, nonatomic) IBOutlet UITextField *channel1Description;
@property (weak, nonatomic) IBOutlet UITextField *channel2Description;
@property (weak, nonatomic) IBOutlet UITextField *channel3Description;
@property (weak, nonatomic) IBOutlet UITextField *channel4Description;

@property (weak, nonatomic) IBOutlet UISlider *keySlider;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

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
@synthesize keySlider = _keySlider;
@synthesize keyLabel = _keyLabel;
@synthesize keyNote = _keyNote;

@synthesize soundGenerator;

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

- (void)setKeyNote:(NSInteger)keyNote{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:keyNote] forKey:NOTE_KEY];
    [defaults synchronize];
}

- (NSInteger)keyNote{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSNumber *keyNote = [defaults objectForKey:NOTE_KEY];
    if(!keyNote){
        keyNote = [NSNumber numberWithInt:DEFAULT_KEY];   
        [defaults setObject:keyNote forKey:NOTE_KEY];
        [defaults synchronize];
    }
    
    return [keyNote intValue];
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
    
    UITextField* label = [self.channelDescriptions objectAtIndex:channel];
    label.text = [NSString stringWithFormat:@"#%d : %@", prog , [NSString stringWithCString:name encoding:NSASCIIStringEncoding]];

}

- (void) updateStepperForChannel:(int)channel{
    UIStepper* stepper = [self.channelSteppers objectAtIndex:channel];
    stepper.value = [[self.channels objectAtIndex:channel] intValue];
}

- (NSString*)noteFromValue:(int)value{
    int noteStep = (value - 21) % 12;
    char *note = notes[noteStep];
    NSString *noteString = [NSString stringWithFormat:@"%s", note];
    if (noteStep == 1 || noteStep == 6 || noteStep == 11) {
        noteString = [noteString stringByAppendingFormat:@"♭"];
    }else if (noteStep == 4 || noteStep == 9){
        noteString = [noteString stringByAppendingFormat:@"♯"];
    }
    int octave = (value - 21) / 12;
    return [NSString stringWithFormat:@"%@%d", noteString, octave];
}

#pragma mark - IBActions

- (IBAction)channelChanged:(UIStepper*)sender {
    [self updateChannel:sender.tag value:sender.value];
    [self updateDescriptionForChannel:sender.tag];
    [self.soundGenerator clearCache];
}

- (IBAction)changeKey:(UISlider*)sender {
    int roundedValue = round(2.0f*sender.value) / 2.0f;
    self.keyNote = roundedValue;

    self.keyLabel.text = [self noteFromValue:roundedValue];
    [self.soundGenerator clearCache];
}

- (IBAction)playSample:(UIButton*)sender {
    self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90 + sender.tag, self.keyNote, 0x7f);    
}

- (IBAction)stopSample:(UIButton*)sender {
    self.appDelegate.api->setChannelMessage (self.appDelegate.handle, 0x00, 0x90 + sender.tag, self.keyNote, 0x00);
}

#pragma mark - Lifecycle

- (void)viewDidLoad{
    NSLog(@"View did load");
    for (int i=0; i<NUMCHANNELS; i++) {
        [self updateStepperForChannel:i];
        [self updateDescriptionForChannel:i];
    }
    self.keySlider.value = self.keyNote;
    self.keyLabel.text = [self noteFromValue:self.keyNote];
    [self.soundGenerator clearCache];
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
    [self setKeySlider:nil];
    [self setKeyLabel:nil];
    [super viewDidUnload];
}

@end
