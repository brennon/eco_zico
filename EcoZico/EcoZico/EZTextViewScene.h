//
//  EZTextViewScene.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 08/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class EZWordLabel, EZBookViewController;

// TODO: position works like anchorpoint is set at 0.5, 0.0 - fix it.

@interface EZTextViewScene : CCLayerColor

@property (nonatomic, assign) EZBookViewController	*ezBookView;
@property (nonatomic, assign) CGFloat				heightOfWords;
@property (nonatomic, assign) CGFloat				inset;
@property (nonatomic, assign) CGFloat				padding;
@property (nonatomic, assign) CGFloat				incY;
@property (nonatomic, assign) CGFloat				x;
@property (nonatomic, assign) CGFloat				y;
@property (nonatomic, assign) BOOL					startOFLine;
@property (nonatomic, assign) CGSize				s;
@property (nonatomic, assign) CGFloat				prevWordWidth;
@property (nonatomic, assign) CGFloat				currentWordWidth;
@property (nonatomic, assign) NSUInteger			idxEndOfline3;
@property (nonatomic, assign) NSUInteger			idxStopPoint;
@property (nonatomic, assign) EZWordLabel			*word;
@property (nonatomic, assign) EZWordLabel			*currentWord;

// Narration
@property (nonatomic, assign) NSUInteger			wordPositionCounter;
@property (nonatomic, retain) NSTimer				*timer;
@property (nonatomic, assign) NSTimeInterval		currentPlaybackPosition;
@property (nonatomic, assign) BOOL					isParaNarrationFinished;

- (id)initWithEZBookView:(EZBookViewController *)anEZBookView;

// Find where to stop laying out words
- (int)stopIdx;

// Layout words to idx found with stopIdx
- (void)layoutWords;

// Callback when a paragraph reaches end of narration
- (void)paraNarrationDidFinish;

// Start/stop polling audio player position
- (void)startPollingPlayer;
- (void)stopPollingPlayer;

// For debugging
- (void)setWordPositionForTime:(NSTimeInterval)time;

@end
