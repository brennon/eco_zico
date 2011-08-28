//
//  EZTextViewScene.m
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 08/07/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import "EZTextViewScene.h"
#import "EZBookViewController.h"
#import "EZWord.h"
#import "EZWordLabel.h"
#import "EZAudioPlayer.h"

#define EZ_MAX_LINES 3

@implementation EZTextViewScene

@synthesize ezBookView				= _ezBookView;
@synthesize word					= _word;
@synthesize currentWord				= _currentWord;
@synthesize heightOfWords			= _heightOfWords;
@synthesize inset					= _inset;
@synthesize padding					= _padding;
@synthesize incY					= _incY;
@synthesize x						= _x;
@synthesize y						= _y;
@synthesize startOFLine				= _startOFLine;
@synthesize s						= _s;
@synthesize prevWordWidth			= _prevWordWidth;
@synthesize currentWordWidth		= _currentWordWidth;
@synthesize idxEndOfline3			= _idxEndOfline3;
@synthesize idxStopPoint			= _idxStopPoint;
@synthesize wordPositionCounter		= _wordPositionCounter;
@synthesize timer					= _timer;
@synthesize currentPlaybackPosition	= _currentPlaybackPosition;
@synthesize isParaNarrationFinished	= _isParaNarrationFinished;

- (id)initWithEZBookView:(EZBookViewController *)anEZBookView;
{
	if((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {    
        self.ezBookView = anEZBookView;
		self.wordPositionCounter = 0;
		self.isParaNarrationFinished = NO;
    }
	return self;
}

- (void)layoutWords
{     
    // measurment vars for laying out words
    
    // height of a label / word
    self.heightOfWords = [[self.ezBookView.ezWordLabels objectAtIndex:0] boundingBox].size.height;
    
    // inset from left and top edge 
    self.inset = 20;
    // space between words
    self.padding = 7;
    // line inc spacing
    self.incY = self.heightOfWords;
    // x and y positioning for each word
	self.y = [self boundingBox].size.height - self.inset;
    self.x = self.inset;    
    
    // whether we are at the start of the line
    self.startOFLine = NO;
    
    // size of the drawable area
    self.s = [[CCDirector sharedDirector] winSize];       
    
    // find the idx of the word at the end of the third line. work backwards from there to find the idx of the word with the first full-stop '.'
    // layout the words to that point.
    
    // point at which to stop laying out words
    self.idxStopPoint = [self stopIdx];
    
    
    // layout the words
    for (int i = self.ezBookView.idxOfLastWordLaidOut; i < [self.ezBookView.ezWordLabels count]; i++) {
        self.word = (EZWordLabel *)[self.ezBookView.ezWordLabels objectAtIndex:i];
        
        if (i > self.ezBookView.idxOfLastWordLaidOut) {
            // width of previous and current word
            self.prevWordWidth = [[self.ezBookView.ezWordLabels objectAtIndex:i - 1] boundingBox].size.width;
            self.currentWordWidth = [self.word boundingBox].size.width;
            
            //if next word will take us past the drawable area, move to the next line
            if ((self.x + self.prevWordWidth + self.currentWordWidth + self.padding) >= self.s.width) {                
                self.y -= self.incY;
                self.x = self.inset;
                self.startOFLine = YES;
            }
            
            //only inc x when not at the start of a line 
            if(self.startOFLine == NO) {
                self.x += (self.prevWordWidth + self.padding);
            } else {
                self.startOFLine = NO;
            }            
        }
        
        self.word.position = ccp(self.x, self.y);
        
        [self addChild:self.word];
        
        // stop laying out when get to the idx found from the first loop.
        if(i == self.idxStopPoint) {
            // record the location of where we stopped so we can start from the right location next time.
            self.ezBookView.idxOfLastWordLaidOut = i + 1;            
            break;
        }
            
        // used for debugging - skipping paragrpahs.
        if (i == [self.ezBookView.ezWordLabels count] - 1) {
            self.ezBookView.idxOfLastWordLaidOut = i;
        }        
	}	    
}

- (int)stopIdx
{
    int returnVal;
    
    int lineNum = 1;    
    
    for (int i = self.ezBookView.idxOfLastWordLaidOut; i < [self.ezBookView.ezWordLabels count]; i++) {
        self.word = (EZWordLabel *)[self.ezBookView.ezWordLabels objectAtIndex:i];
        
        if(i > self.ezBookView.idxOfLastWordLaidOut) {
            // width of previous and current word
            self.prevWordWidth = [[self.ezBookView.ezWordLabels objectAtIndex:i - 1] boundingBox].size.width;
            self.currentWordWidth = [self.word boundingBox].size.width;
            
            // if next word will take us past the drawable area, move to the next line
            if ((self.x + self.prevWordWidth + self.currentWordWidth + self.padding) >= self.s.width) {
                lineNum++;
                self.x = self.inset;
                self.startOFLine = YES;
            }            
            
            // find the idx of the word at the end of the third line.
            if (lineNum == (EZ_MAX_LINES + 1) && self.startOFLine == YES) {
                //we are at the start of the fourth line so, one word back is the end of the third.
                self.idxEndOfline3 = i - 1;
                
                // work backwards from there to find the idx of the word with the first full-stop '.'
                for (int i = self.idxEndOfline3; i >= 0; i--) {
                    EZWordLabel *wordToCheckForPeriod = [self.ezBookView.ezWordLabels objectAtIndex:i];
                    
                    if ([[wordToCheckForPeriod string] hasSuffix:@"."]) {
                        // idx of the word at which to stop laying out, i.e. next word with a '.' from the end of the third line (working backwards)
                        returnVal = i;
                        break;
                    }        
                }
                
                break;
            }
            
            //only inc x when not at the start of a line 
            if (self.startOFLine == NO) {
                self.x += (self.prevWordWidth + self.padding);
            } else {
                self.startOFLine = NO;
            }            
        }        
	}    
    
    self.x = self.inset;//reset
    self.startOFLine = NO;//reset
    
    return returnVal;    
}

- (void)setWordPositionForTime:(NSTimeInterval)time
{    
    for (int i = 0; i < [self.ezBookView.ezWordLabels count]; i++) {
        EZWordLabel *labelToCheck = (EZWordLabel *)[self.ezBookView.ezWordLabels objectAtIndex:i];
        if ((NSTimeInterval)[labelToCheck.seekPoint doubleValue] >= time) {
            self.wordPositionCounter = i;
            
            EZWordLabel *wordForCurrentTime = (EZWordLabel *)[self.ezBookView.ezWordLabels objectAtIndex:self.wordPositionCounter]; 
            
            self.ezBookView.ezAudioPlayer.currentTime = (NSTimeInterval)[wordForCurrentTime.seekPoint doubleValue];
            
            break;
        }
    }
}

- (void)startPollingPlayer
{
    //start a timer which polls the avaudio player obj for it's current position.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(pollPlaybackTime) userInfo:nil repeats:YES];   
}

- (void)stopPollingPlayer
{
    [_timer invalidate];
    self.timer = nil;
}

- (void)pollPlaybackTime
{
    self.currentPlaybackPosition = [self.ezBookView.ezAudioPlayer currentTime];// current playback pos
    
    if (self.wordPositionCounter < [self.ezBookView.ezWordLabels count] && !self.isParaNarrationFinished) {
        EZWordLabel *wordForCurrentPosition = (EZWordLabel *)[self.ezBookView.ezWordLabels objectAtIndex:self.wordPositionCounter];
        
        if (self.currentPlaybackPosition >= [wordForCurrentPosition.seekPoint doubleValue]) {
            if (self.wordPositionCounter > 0) {
                [[self.ezBookView.ezWordLabels objectAtIndex:self.wordPositionCounter - 1] startWordOffAnimation];
            }            
            
            //if playback pos is beyond next word in word array set it as the current word
            self.currentWord = [self.ezBookView.ezWordLabels objectAtIndex:self.wordPositionCounter];
            
            //do some animation
            [self.currentWord startWordOnAnimation];
            
            //inc the counter
            self.wordPositionCounter++;
        }
        
        if (self.wordPositionCounter > self.idxStopPoint && self.wordPositionCounter < [self.ezBookView.ezWordLabels count]) {   
            self.isParaNarrationFinished = YES;//only allow this block to be called once
            
            DebugLog(@"isParaNarrationFinished = YES");
                        
            [self stopPollingPlayer];
            
            double timeToWait = [[[self.ezBookView.ezWordLabels objectAtIndex:self.wordPositionCounter] seekPoint] doubleValue] - [self.currentWord.seekPoint doubleValue];
            
            [self performSelector:@selector(paraNarrationDidFinish) withObject:nil afterDelay:timeToWait];
        }
    }
    
}

- (void)paraNarrationDidFinish
{    
    [self.currentWord startWordOffAnimation];    
    [self.ezBookView textViewDidFinishNarratingParagraph];    
}

- (void)dealloc
{    
	[super dealloc];
}

// Not used
- (void)setPlayPosition:(NSTimeInterval)pos
{
    self.ezBookView.ezAudioPlayer.currentTime = self.ezBookView.ezAudioPlayer.duration / pos;
}

@end