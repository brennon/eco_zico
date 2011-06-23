//
//  EcoZicoAppDelegate.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EZBookViewController;

@interface EcoZicoAppDelegate : NSObject <UIApplicationDelegate> {
    EZBookViewController *bookViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) EZBookViewController *bookViewController;

@end
