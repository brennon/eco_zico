//
//  EcoZicoAppDelegate.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EcoZicoAppDelegate.h"
#import "EZBookViewController.h"
#import "EZFrontViewController.h"
#import "EZHelpViewController.h"

// #define SKIP_MENU

@implementation EcoZicoAppDelegate

@synthesize shouldContinueFromLastPageReached = _shouldContinueFromLastPageReached;
@synthesize window          = _window;
@synthesize readItMyself    = _readItMyself;

- (void)switchToBookViewController
{
    self.window.rootViewController = (UIViewController *)[[EZBookViewController alloc] init];
    [self.window makeKeyAndVisible];
}

- (void)switchToHelpViewController
{
    self.window.rootViewController = (UIViewController *)[[EZHelpViewController alloc] init];
    [self.window makeKeyAndVisible];
}

- (void)switchToFrontViewController
{
    self.window.rootViewController = (UIViewController *)[[EZFrontViewController alloc] init];
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef SKIP_MENU
    self.window.rootViewController = (UIViewController *)[[EZBookViewController alloc] init];
	[self.window makeKeyAndVisible];
#else    
	self.window.rootViewController = (UIViewController *)[[EZFrontViewController alloc] init];
	[self.window makeKeyAndVisible];
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
	self.window = nil;
    [super dealloc];
}

@end
