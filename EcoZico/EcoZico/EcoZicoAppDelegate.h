//
//  EcoZicoAppDelegate.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcoZicoAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)switchToFrontViewController;
- (void)switchToBookViewController;
- (void)switchToHelpViewController;

@end