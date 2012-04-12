//
//  AppDelegate.h
//  Enduro
//
//  Created by Phillip Tang on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "crmd.h"

@class EnduroViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CRMD_HANDLE handle;
	CRMD_FUNC *api;
	
    BOOL mix;
}
@property CRMD_HANDLE handle;
@property CRMD_FUNC *api;

@property BOOL mix;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (strong, nonatomic, retain) UINavigationController *navController;
@property (strong, nonatomic, retain) UIViewController *viewController;

@end
