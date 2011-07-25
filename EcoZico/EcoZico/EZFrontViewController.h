//
//  EZFrontViewController.h
//  EcoZico
//
//  Created by Brennon Bortz on 23/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EZFrontViewController : UIViewController {
    IBOutlet UIButton *readItToMeButton;
    IBOutlet UIButton *readItMyselfButton;
    IBOutlet UIButton *helpButton;
}

@property (nonatomic, retain) UIButton *readItToMeButton;
@property (nonatomic, retain) UIButton *readItToMyselfButton;
@property (nonatomic, retain) UIButton *helpButton;

- (IBAction)readItToMeButtonPushed;
- (IBAction)readItMyselfButtonPushed;
- (IBAction)helpButtonPushed;

@end
