//
//  EZFrontViewController.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 23/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EZFrontViewController : UIViewController {
    UIButton *helpButton;
    UIButton *readItMyselfButton;
    UIButton *readItToMeButton;
}

@property (nonatomic, retain) IBOutlet UIButton *helpButton;
@property (nonatomic, retain) IBOutlet UIButton *readItMyselfButton;
@property (nonatomic, retain) IBOutlet UIButton *readItToMeButton;

- (IBAction)readItToMeButtonPushed;
- (IBAction)readItMyselfButtonPushed;
- (IBAction)helpButtonPushed;

@end
