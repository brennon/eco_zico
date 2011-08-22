//
//  EZHelpViewController.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 27/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EZHelpViewController : UIViewController {
    CGRect handRects[4];
}

@property (nonatomic, retain) IBOutlet UIImageView *handView;
@property (nonatomic, retain) IBOutlet UIView *screenView;
@property (nonatomic, retain) IBOutlet UIImageView *textView;
@property (nonatomic, retain) NSNumber *currentInstructions;
@property (nonatomic, retain) NSArray *textImageFilenames;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonPushed:(id)sender;
- (IBAction)exitButtonPushed:(id)sender;

@end