//
//  HelpBubble.m
//  BrainJogV1
//
//  Created by Donal O'Brien on 03/09/2010.
//  Copyright 2010 Queens University Belfast. All rights reserved.
//

#import "EZTextViewController.h"
#import "EZPageView.h"
#import "EZWord.h"

#define EZ_MAX_LINES 3

@implementation EZTextViewController

@synthesize page;


-(id)initWithPage:(EZPageView*)pageView;
{
	if((self = [super init]))
	{    
        page = pageView;        		
    }
	
	return self;
}




-(void)layoutWords
{     
    //measurment vars for laying out words
    
    //height of a label / word
    heightOfWords = [[page.words objectAtIndex:0]boundingBox].size.height;
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
    
    
    //layout the words
    for(int i = page.idxOfLastWordLaidOut; i < [page.words count]; i++)
	{
        word = [page.words objectAtIndex:i];
        
        if(i > page.idxOfLastWordLaidOut)
        {
            //width of previous and current word
            prevWordWidth = [[page.words objectAtIndex:i - 1]boundingBox].size.width;
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
            page.idxOfLastWordLaidOut = i + 1;
            break;
        }
 
	}	    
    
    if(word != [page.words lastObject])
       [self performSelector:@selector(paraNarrationDidFinish) withObject:nil afterDelay:4];
}


-(int)stopIdx
{
    int returnVal;
    
    int lineNum = 1;
    
    
    for(int i = page.idxOfLastWordLaidOut; i < [page.words count]; i++)
	{
        word = [page.words objectAtIndex:i];
        
        if(i > page.idxOfLastWordLaidOut)
        {
            //width of previous and current word
            prevWordWidth = [[page.words objectAtIndex:i - 1]boundingBox].size.width;
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
                    EZWord *wordToCheckForPeriod = [page.words objectAtIndex:i];
                    
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

//temp
-(void)paraNarrationDidFinish
{
    [page textViewDidFinishNarratingParagraph];    
}


-(void)dealloc
{
	[super dealloc];	
}


@end
