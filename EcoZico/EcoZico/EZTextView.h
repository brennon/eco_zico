//
//  EZTextView.h
//  EcoZico
//
//  Created by Brennon Bortz on 01/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@class EZPage;

@interface EZTextView : UIView {
    NSArray *ezWordLabels;
}

@property (nonatomic, retain) NSArray *ezWordLabels;

- (void)attachCocos2dToSelf;
- (void)loadNewPage:(EZPage *)ezPage;

@end
