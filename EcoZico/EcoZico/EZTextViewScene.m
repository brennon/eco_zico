//
//  EZTextViewScene.m
//  EcoZico
//
//  Created by Brennon Bortz on 08/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import "EZTextViewScene.h"
#import "EZTextView.h"
#import "EZWord.h"
#import "EZWordLabel.h"

#define EZ_MAX_LINES 3

@implementation EZTextViewScene

@synthesize ezTextView;


- (id)initWithEZTextView:(EZTextView *)anEZTextView;
{
	if((self = [super initWithColor:ccc4(255, 255, 255, 255)]))
	{    
        self.ezTextView = anEZTextView;
    }
	
	return self;
}


-(void)layoutWords
{     
    //measurment vars for laying out words
    
    //height of a label / word
    heightOfWords = [[ezTextView.ezWordLabels objectAtIndex:0] boundingBox].size.height;
    
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
    for(int i = ezTextView.idxOfLastWordLaidOut; i < [ezTextView.ezWordLabels count]; i++)
	{
        word = (EZWordLabel *)[ezTextView.ezWordLabels objectAtIndex:i];
        
        if(i > ezTextView.idxOfLastWordLaidOut)
        {
            //width of previous and current word
            prevWordWidth = [[ezTextView.ezWordLabels objectAtIndex:i - 1]boundingBox].size.width;
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
            ezTextView.idxOfLastWordLaidOut = i + 1;
            break;
        }
        
	}	    
}


-(int)stopIdx
{
    int returnVal;
    
    int lineNum = 1;
    
    
    for(int i = ezTextView.idxOfLastWordLaidOut; i < [ezTextView.ezWordLabels count]; i++)
	{
        word = (EZWordLabel *)[ezTextView.ezWordLabels objectAtIndex:i];
        
        if(i > ezTextView.idxOfLastWordLaidOut)
        {
            //width of previous and current word
            prevWordWidth = [[ezTextView.ezWordLabels objectAtIndex:i - 1]boundingBox].size.width;
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
                    EZWordLabel *wordToCheckForPeriod = [ezTextView.ezWordLabels objectAtIndex:i];
                    
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
    for (int i = 0; i < [ezTextView.ezWordLabels count]; i++)
    {
        EZWordLabel *labelToCheck = (EZWordLabel *)[ezTextView.ezWordLabels objectAtIndex:i];
        if ((NSTimeInterval)[labelToCheck.seekPoint doubleValue] >= time)
        {
            wordPositionCounter = i;
            
            EZWordLabel *wordForCurrentTime = (EZWordLabel *)[ezTextView.ezWordLabels objectAtIndex:wordPositionCounter]; 
            
            ezTextView.player.currentTime = (NSTimeInterval)[wordForCurrentTime.seekPoint doubleValue];
            
            break;
        }
    }
}


-(void)playPause
{
    //pause
    if([ezTextView.player isPlaying])
    {
        NSLog(@"tv pause");
        [timer invalidate];
        timer = nil;
    }
    //play
    else 
    {
        NSLog(@"tv play");
        //start a timer which polls the avaudio player obj for it's current position.
        timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(pollPlaybackTime) userInfo:nil repeats:YES];
    }
}


-(void)pollPlaybackTime
{
    currentPlaybackPosition = [ezTextView.player currentTime];// current playback pos
    
    if(wordPositionCounter < [ezTextView.ezWordLabels count])
    {
        EZWordLabel *wordForCurrentPosition = (EZWordLabel *)[ezTextView.ezWordLabels objectAtIndex:wordPositionCounter];
        
        if(currentPlaybackPosition >= [wordForCurrentPosition.seekPoint doubleValue])
        {
            if (wordPositionCounter > 0) 
            {
                [[ezTextView.ezWordLabels objectAtIndex:wordPositionCounter - 1] startWordOffAnimation];
            }            
            
            //if playback pos is beyond next word in word array set it as the current word
            currentWord = [ezTextView.ezWordLabels objectAtIndex:wordPositionCounter];
            
            //do some animation
            [currentWord startWordOnAnimation];
            
            //inc the counter
            wordPositionCounter++;
        }
        
        if(wordPositionCounter > idxStopPoint && wordPositionCounter < [ezTextView.ezWordLabels count] && !isParaNarrationFinished)
        {     
            isParaNarrationFinished = YES;//only allow this block to be called once
            
            NSLog(@"tv pollPlaybackTime wordPositionCounter > idxStopPoint");
            
            [self playPause];
            
            double timeToWait = [[[ezTextView.ezWordLabels objectAtIndex:wordPositionCounter] seekPoint] doubleValue] - [currentWord.seekPoint doubleValue];
            
            [self performSelector:@selector(paraNarrationDidFinish) withObject:nil afterDelay:timeToWait];
        }
    }
    
}

//not used
-(void)setPlayPosition:(NSTimeInterval)pos
{
    ezTextView.player.currentTime = ezTextView.player.duration / pos;
}


-(void)paraNarrationDidFinish
{    
    
    NSLog(@"tv paraNarrationDidFinish");
    
    [currentWord startWordOffAnimation];
    
    [ezTextView textViewDidFinishNarratingParagraph];    
}


-(void)dealloc
{
    NSLog(@"tv dealloc");
    
	[super dealloc];
}


@end