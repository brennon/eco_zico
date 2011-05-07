//
//  HelpBubble.m
//  BrainJogV1
//
//  Created by Donal O'Brien on 03/09/2010.
//  Copyright 2010 Queens University Belfast. All rights reserved.
//

#import "TextViewController.h"
#import "EZWord.h"


@implementation TextViewController

@synthesize initMessage, view, words;


-(id)initWithText:(NSString*)text
{
	if((self = [super init]))
	{        
        view = [[CCLayerColor alloc]initWithColor:ccc4(0, 0, 0, 255)];
        
		initMessage = [[NSString stringWithString:text]retain];
        
        //get the array of EZWord objects
        words = [[self wordObjsForWordsInString:initMessage]retain];
		
        //lay out the words to fit the drawable area
		[self layoutWords];        		
    }
	
	return self;
}


-(NSArray*)wordObjsForWordsInString:(NSString*)str
{
    //NSArray of individual words from the string
    NSArray *fullMsg = [initMessage componentsSeparatedByString:@" "];
    
    NSMutableArray *wordsAr = [NSMutableArray array];
    
    for (NSString *str in fullMsg)
    {
        //EZWord's are created from Lucidia30.fnt which references Lucidia30.png
		EZWord *word = [[EZWord alloc]initWithString:str fntFile:@"Lucidia30.fnt"];
        
        //transformations, i.e. scale, position etc. occur around the anchor point. 0,0 is bottom left. set it to top left.
        word.anchorPoint = ccp(0, 1);
        
        [wordsAr addObject:word];
    }
    
    return wordsAr;
}


-(void)layoutWords
{   
    //measurment vars for laying out words
    
    //height of a label / word
    float heightOfWords = [[words objectAtIndex:0]boundingBox].size.height;
    //inset from left and top edge 
    float inset = 20;
    //space between words
    float padding = 7;
    //line inc spacing
    float incY = heightOfWords;
    //x and y for each word
	float y = [self.view boundingBox].size.height - inset;
    float x = inset;    
    
    //whether we are at the start of the line
    BOOL startOFLine = NO;
    
    //size of the drawable area
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    for(int i = 0; i < [words count]; i++)
	{
        EZWord *word = [words objectAtIndex:i];
        
        if(i > 0)
        {
            //width of previous and current word
            float prevWordWidth = [[words objectAtIndex:i - 1]boundingBox].size.width;
            float currentWordWidth = [word boundingBox].size.width;
            
            //if next word will take us past the drawable area, move to the next line
            if ((x + prevWordWidth + currentWordWidth + padding) >= s.width) 
            {
                y -= incY;
                x = inset;
                startOFLine = YES;
            }
            
            //only in x when not at the start of a line 
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
        
        [self.view addChild:word];
 
	}	    
}


-(void)dealloc
{
    [words release];
    [view release];
	[initMessage release];
	[super dealloc];	
}


@end
