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

@synthesize ezBookView;


- (id)initWithEZBookView:(EZBookViewController *)anEZBookView;
{
	if((self = [super initWithColor:ccc4(255, 255, 255, 255)]))
	{    
        self.ezBookView = anEZBookView;
    }
	
	return self;
}


-(void)layoutWords
{     
    //measurment vars for laying out words
    
    //height of a label / word
    heightOfWords = [[ezBookView.ezWordLabels objectAtIndex:0] boundingBox].size.height;
    
    //inset from left and top edge 
    inset = 20;
    //space between words
    padding = 7;
    //line inc spacing
    incY = heightOfWords;
    //x and y positioning for each word
	y = [self boundingBox].size.height - inset;
    x = inset;    
    
    //whether we are at the start of the line
    startOFLine = NO;
    
    //size of the drawable area
    s = [[CCDirector sharedDirector] winSize];       
    
    // find the idx of the word at the end of the third line. work backwards from there to find the idx of the word with the first full-stop '.'
    // layout the words to that point.
    
    // point at which to stop laying out words
    idxStopPoint = [self stopIdx];
    
    
    // layout the words
    for(int i = ezBookView.idxOfLastWordLaidOut; i < [ezBookView.ezWordLabels count]; i++)
	{
        word = (EZWordLabel *)[ezBookView.ezWordLabels objectAtIndex:i];
        
        if(i > ezBookView.idxOfLastWordLaidOut)
        {
            //width of previous and current word
            prevWordWidth = [[ezBookView.ezWordLabels objectAtIndex:i - 1]boundingBox].size.width;
            currentWordWidth = [word boundingBox].size.width;
            
            //if next word will take us past the drawable area, move to the next line
            if ((x + prevWordWidth + currentWordWidth + padding) >= s.width) 
            {                
                y -= incY;
                x = inset;
                startOFLine = YES;
            }
            
            //only inc x when not at the start of a line 
            if(startOFLine == NO)
            {
                x += (prevWordWidth + padding);
            }
            else
            {
                startOFLine = NO;
            }            
        }
        
        word.position = ccp(x, y);
        
        [self addChild:word];
        
        // stop laying out when get to the idx found from the first loop.
        if(i == idxStopPoint)
        {
            //record the location of where we stopped so we can start from the right location next time.
            ezBookView.idxOfLastWordLaidOut = i + 1;
            
            break;
        }
            
        //used for debugging - skipping paragrpahs.
        if(i == [ezBookView.ezWordLabels count] - 1)
        {
            ezBookView.idxOfLastWordLaidOut = i;
        }

        
	}	    
}


-(int)stopIdx
{
    int returnVal;
    
    int lineNum = 1;
    
    
    for(int i = ezBookView.idxOfLastWordLaidOut; i < [ezBookView.ezWordLabels count]; i++)
	{
        word = (EZWordLabel *)[ezBookView.ezWordLabels objectAtIndex:i];
        
        if(i > ezBookView.idxOfLastWordLaidOut)
        {
            //width of previous and current word
            prevWordWidth = [[ezBookView.ezWordLabels objectAtIndex:i - 1]boundingBox].size.width;
            currentWordWidth = [word boundingBox].size.width;
            
            //if next word will take us past the drawable area, move to the next line
            if ((x + prevWordWidth + currentWordWidth + padding) >= s.width) 
            {
                lineNum++;
                x = inset;
                startOFLine = YES;
            }            
            
            // find the idx of the word at the end of the third line.
            if(lineNum == (EZ_MAX_LINES + 1) && startOFLine == YES)
            {
                //we are at the start of the fourth line so, one word back is the end of the third.
                idxEndOfline3 = i - 1;
                
                // work backwards from there to find the idx of the word with the first full-stop '.'
                for(int i = idxEndOfline3; i >= 0; i--)
                {
                    EZWordLabel *wordToCheckForPeriod = [ezBookView.ezWordLabels objectAtIndex:i];
                    
                    if([[wordToCheckForPeriod string] hasSuffix:@"."])
                    {
                        // idx of the word at which to stop laying out, i.e. next word with a '.' from the end of the third line (working backwards)
                        returnVal = i;
                        break;
                    }        
                }
                
                break;
            }
            
            //only inc x when not at the start of a line 
            if(startOFLine == NO)
            {
                x += (prevWordWidth + padding);
            }
            else
            {
                startOFLine = NO;
            }            
        }        
	}
    
    
    x = inset;//reset
    startOFLine = NO;//reset
    
    return returnVal;    
}


-(void)setWordPositionForTime:(NSTimeInterval)time
{    
    for (int i = 0; i < [ezBookView.ezWordLabels count]; i++)
    {
        EZWordLabel *labelToCheck = (EZWordLabel *)[ezBookView.ezWordLabels objectAtIndex:i];
        if ((NSTimeInterval)[labelToCheck.seekPoint doubleValue] >= time)
        {
            wordPositionCounter = i;
            
            EZWordLabel *wordForCurrentTime = (EZWordLabel *)[ezBookView.ezWordLabels objectAtIndex:wordPositionCounter]; 
            
            ezBookView.ezAudioPlayer.currentTime = (NSTimeInterval)[wordForCurrentTime.seekPoint doubleValue];
            
            break;
        }
    }
}

-(void)startPollingPlayer
{
    //start a timer which polls the avaudio player obj for it's current position.
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(pollPlaybackTime) userInfo:nil repeats:YES];   
}


-(void)stopPollingPlayer
{
    [timer invalidate];
    timer = nil;
}



-(void)pollPlaybackTime
{
    currentPlaybackPosition = [ezBookView.ezAudioPlayer currentTime];// current playback pos
    
    if(wordPositionCounter < [ezBookView.ezWordLabels count] && !isParaNarrationFinished)
    {
        EZWordLabel *wordForCurrentPosition = (EZWordLabel *)[ezBookView.ezWordLabels objectAtIndex:wordPositionCounter];
        
        if(currentPlaybackPosition >= [wordForCurrentPosition.seekPoint doubleValue])
        {
            if (wordPositionCounter > 0) 
            {
                [[ezBookView.ezWordLabels objectAtIndex:wordPositionCounter - 1] startWordOffAnimation];
            }            
            
            //if playback pos is beyond next word in word array set it as the current word
            currentWord = [ezBookView.ezWordLabels objectAtIndex:wordPositionCounter];
            
            //do some animation
            [currentWord startWordOnAnimation];
            
            //inc the counter
            wordPositionCounter++;
        }
        
        if(wordPositionCounter > idxStopPoint && wordPositionCounter < [ezBookView.ezWordLabels count])
        {   
            isParaNarrationFinished = YES;//only allow this block to be called once
            
            DebugLog(@"isParaNarrationFinished = YES");
                        
            [self stopPollingPlayer];
            
            double timeToWait = [[[ezBookView.ezWordLabels objectAtIndex:wordPositionCounter] seekPoint] doubleValue] - [currentWord.seekPoint doubleValue];
            
            [self performSelector:@selector(paraNarrationDidFinish) withObject:nil afterDelay:timeToWait];
        }
    }
    
}



-(void)paraNarrationDidFinish
{    
    [currentWord startWordOffAnimation];
    
    [ezBookView textViewDidFinishNarratingParagraph];    
}


//not used
-(void)setPlayPosition:(NSTimeInterval)pos
{
    ezBookView.ezAudioPlayer.currentTime = ezBookView.ezAudioPlayer.duration / pos;
}


-(void)dealloc
{    
	[super dealloc];
}


@end