//
//  EZTextViewScene.h
//  EcoZico
//
//  Created by Brennon Bortz on 08/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class EZWordLabel, EZTextView;

//TODO: position works like anchorpoint is set at 0.5, 0.0 - fix it.

@interface EZTextViewScene : CCLayerColor {
    EZTextView *ezTextView;
    
    float heightOfWords;
    float inset;
    float padding;
    float incY;
    float x, y;
    BOOL startOFLine;
    CGSize s;
    float prevWordWidth;
    float currentWordWidth;
    EZWordLabel *word;
    
    int idxEndOfline3;
    int idxStopPoint;
    
    //narration
    int wordPositionCounter;
    NSTimer *timer;
    EZWordLabel *currentWord;
    NSTimeInterval currentPlaybackPosition;
    BOOL isParaNarrationFinished;
}

@property(nonatomic, assign) EZTextView *ezTextView;

- (id)initWithEZTextView:(EZTextView *)anEZTextView;

//find where to stop laying out words
-(int)stopIdx;

//layout words to idx found with stopIdx
-(void)layoutWords;

//callback when a para reaches end of narration
-(void)paraNarrationDidFinish;

//pause / resume timers (used for polling audio player position)
-(void)playPause;

//for debugging
-(void)setWordPositionForTime:(NSTimeInterval)time;

@end
