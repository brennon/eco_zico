//
//  EcoZicoAppDelegate.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcoZicoAppDelegate : NSObject <UIApplicationDelegate>

@property BOOL shouldContinueFromLastPageReached;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) BOOL readItMyself;

- (void)switchToFrontViewController;
- (void)switchToBookViewController;
- (void)switchToHelpViewController;

@end