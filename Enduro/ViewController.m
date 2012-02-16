//
//  ViewController.m
//  Enduro
//
//  Created by Phillip Tang on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) listPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@", [paths componentsJoinedByString: @", "]);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"%@", documentsDirectory);

    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSLog(@"%@", documentsDirectory);
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];   
    
//    return documentsDirectory;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return ;
    }
    NSLog(@"%@", [files componentsJoinedByString: @", "]);
    
    
    
    for (NSString *filename in files) {
        NSString *filepath = [NSString stringWithFormat: @"%@/%@", documentsDirectory, filename];
        
        if ([[NSFileManager defaultManager] isReadableFileAtPath:filepath]) {
            NSData *data = [NSData dataWithContentsOfFile: filepath];
            
            NSString * fileContents = [[NSString alloc] initWithBytes:[data bytes]
                                                               length:[data length] 
                                                             encoding:NSUTF8StringEncoding];
            
            //split the string around newline characters to create an array
//            NSString* delimiter = @"\n";
//            NSArray* items = [string componentsSeparatedByString:delimiter];
            
            NSLog(@"%@", fileContents);
        }
    }
    
//    return [files componentsJoinedByString: @", "]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self listPrivateDocsDir];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
