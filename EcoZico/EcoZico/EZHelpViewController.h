//
//  EZHelpViewController.h
//  EcoZico
//
//  Created by Brennon Bortz on 27/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EZHelpViewController : UIViewController {
    IBOutlet UIImageView *handView;
    IBOutlet UIView *screenView;
    IBOutlet UIImageView *textView;
    IBOutlet UIButton *nextButton;
    
    NSNumber *currentInstructions;
    NSArray *textImageFilenames;
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