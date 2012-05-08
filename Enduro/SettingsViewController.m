//
//  SettingsViewController.m
//  Enduro
//
//  Created by Phillip Tang on 5/8/12.
//  Copyright (c) 2012 Microsoft. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property(strong, nonatomic) IBOutlet UIView *settingsView;
@end

@implementation SettingsViewController
@synthesize channels = _channels;
@synthesize settingsView;

- (NSArray*)channels{
    if (!_channels) {
        _channels = [NSArray arrayWithObjects:
                     [NSNumber numberWithInt:0], 
                     [NSNumber numberWithInt:50], 
                     [NSNumber numberWithInt:40],
                     [NSNumber numberWithInt:48],
                     nil];
    }
    return _channels;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [[segue identifier] isEqualToString:@"popover"] )
    {
        //[[segue destinationViewController] setDelegate:self];
        NSLog(@"%@",[[segue destinationViewController] viewControllers]);
//        self.popSegue = (UIStoryboardPopoverSegue*)segue;
    }
    NSLog(@"Inside Segue.");
}


@end
