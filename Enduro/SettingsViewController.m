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
@synthesize settingsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [self.view insertSubview:self.settingsView atIndex:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
