//
//  MIDIViewController.m
//  Enduro
//
//  Created by Benjamin Koltai on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MIDIViewController.h"
#import "AppDelegate.h"

@interface MIDIViewController ()
- (void)updateProgram;
@property (weak, nonatomic) IBOutlet UILabel *programLabel;
@end


@implementation MIDIViewController
@synthesize programLabel;

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self updateProgram];
    
	// send system exclusive
	{
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        //		unsigned char sysex[13] = {0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x00, 0x00, 0x00, 0x01, 0x08, 0x00, 0xF7}; // -100[cent]
		unsigned char sysex[13] = {0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0xF7}; // 0[cent]
        //		unsigned char sysex[13] = {0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x00, 0x00, 0x07, 0x0E, 0x08, 0x00, 0xF7}; // +100[cent]
		appDelegate.api->setSystemExclusiveMessage (appDelegate.handle, 0, 0xF0, sysex, 13);
	}
}

#define NOTE 4
- (IBAction)noteOn:(id)sender
{
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	appDelegate.api->setChannelMessage (appDelegate.handle, 0x00, 0x90, 48 + NOTE, 0x7F);
}

- (IBAction)noteOff:(id)sender
{
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	appDelegate.api->setChannelMessage (appDelegate.handle, 0x00, 0x90, 48 + NOTE, 0x00);
}

- (void)updateProgram
{
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	char name[128];
	appDelegate.api->ctrl (appDelegate.handle, CRMD_CTRL_GET_INSTRUMENT_NAME, name, sizeof (name));
	
	NSString *string = [NSString stringWithFormat:@"#%03d : %@", program, [NSString stringWithCString:name encoding:NSASCIIStringEncoding]];
	[programLabel setText:string];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setProgramLabel:nil];
    [super viewDidUnload];
}
@end
