//
//  EZFrontViewController.h
//  EcoZico
//
//  Created by Brennon Bortz on 23/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
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
