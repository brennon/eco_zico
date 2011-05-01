//
//  BookViewController.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookViewController : UIViewController {
    IBOutlet UIScrollView *pageScrollView;
    UIView *sentenceView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *pageScrollView;

-(void)attachCocos2dViewAndRunLabelActions;

@end
