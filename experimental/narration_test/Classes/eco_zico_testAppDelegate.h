//
//  eco_zico_testAppDelegate.h
//  eco zico test
//
//  Created by Donal O'Brien on 09/04/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eco_zico_testViewController;

@interface eco_zico_testAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    eco_zico_testViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet eco_zico_testViewController *viewController;

@end

