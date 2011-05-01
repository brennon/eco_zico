//
//  EcoZicoAppDelegate.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookViewController;

@interface EcoZicoAppDelegate : NSObject <UIApplicationDelegate> {
    BookViewController *bookViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) BookViewController *bookViewController;

@end
