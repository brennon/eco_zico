//
//  BookViewController.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZPageView.h"

#define PLAY_PAUSE_BUTTON_WIDTH 85

@interface EZBookViewController : UIViewController 
{
    IBOutlet EZPageView *ezPageView;
    UIView *sentenceView;
    
    //TEMP - page text
    NSString *loadOfText;
}

@property (nonatomic, retain) NSString *loadOfText;
@property (nonatomic, retain) IBOutlet EZPageView *ezPageView;

-(void)attachCocos2dView;

@end
