//
//  EZTextViewScene.h
//  EcoZico
//
//  Created by Brennon Bortz on 08/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class EZWordLabel, EZBookViewController;

//TODO: position works like anchorpoint is set at 0.5, 0.0 - fix it.

@interface EZTextViewScene : CCLayerColor {
    EZBookViewController *ezBookView;
    
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

@property(nonatomic, assign) EZBookViewController *ezBookView;

- (id)initWithEZBookView:(EZBookViewController *)anEZBookView;

//find where to stop laying out words
-(int)stopIdx;

//layout words to idx found with stopIdx
-(void)layoutWords;

//callback when a para reaches end of narration
-(void)paraNarrationDidFinish;

//start / stop polling audio player position
-(void)startPollingPlayer;

-(void)stopPollingPlayer;

//for debugging
-(void)setWordPositionForTime:(NSTimeInterval)time;

@end
