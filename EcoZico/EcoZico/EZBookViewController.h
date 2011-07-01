//
//  BookViewController.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZPageView, EZTextView;

@interface EZBookViewController : UIViewController {
    IBOutlet EZPageView *ezPageView;
    IBOutlet EZTextView *ezTextView;
}

@property (nonatomic, retain) IBOutlet EZPageView *ezPageView;
@property (nonatomic, retain) IBOutlet EZTextView *ezTextView;

@end
