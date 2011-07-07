//
//  BookViewController.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PLAY_PAUSE_BUTTON_WIDTH 85

@class EZPageView, EZTextView, EZBook;

@interface EZBookViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet    EZPageView  *ezPageView;
    IBOutlet    EZTextView  *ezTextView;
    
                EZBook      *ezBook;    
                NSNumber    *currentPage;
}

@property (nonatomic, retain) IBOutlet  EZPageView  *ezPageView;
@property (nonatomic, retain) IBOutlet  EZTextView  *ezTextView;
@property (nonatomic, retain)           EZBook      *ezBook;
@property (nonatomic, retain)           NSNumber    *currentPage;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
