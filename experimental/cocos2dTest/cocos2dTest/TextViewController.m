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

@synthesize initMessage, bubbleSize, fontName, fontColour, view;


-(id)initWithMessage:(NSString*)message size:(CGSize)s fontSize:(float)fntSize background:(BOOL)background fontName:(NSString*)fntName fontColour:(ccColor3B)fntColour
{
	fontName = [[NSString alloc]initWithString:fntName];//so can override defualt font name...
	
	fontColour = fntColour;//and font colour after.

	self = [self initWithMessage:message size:s fontSize:fntSize background:background];//do this first...

	return self;
}


-(id)initWithMessage:(NSString*)message size:(CGSize)s fontSize:(float)fntSize background:(BOOL)background
{
	if((self = [super init]))
	{
        
        view = [[CCNode alloc]init];
        
		fontName = [[NSString alloc]initWithString:@"Marker Felt"];//default
		
		fontColour = ccc3(0, 0, 0);
		
		initMessage = [[NSString stringWithString:message]retain];
		
		msgSubstringArray = [[NSMutableArray alloc]initWithCapacity:1];
		
		bubbleSize = s;
		
		fontSize = fntSize;
		
		[self createArrayOfMessagesToFitScreenWithMessage:message];	
		
		[self addMessageComponents];
		
		self.view.contentSize = [self calcWidthAndHeightOfMessage];
		
		if (background)
		{			
			bg = [[CCSprite alloc]initWithFile:@"single_pixel.png"];//whitebgborder
			CCSprite *bgBg = [[CCSprite alloc]initWithFile:@"single_pixel.png"];//whitebgborder
			
			bg.scaleX = self.view.contentSize.width * 1.1;
			bg.scaleY = self.view.contentSize.height * 1.1;
		
			bgBg.scaleX = self.view.contentSize.width * 1.13;
			bgBg.scaleY = self.view.contentSize.height * 1.13;
			
			bg.color = ccc3(176, 226, 255);//176;226;255
			bgBg.color = ccc3(39,64,139);//39;64;139
		
			bg.opacity = 150;
			bgBg.opacity = 100;
			
			CGRect frame = [self.view boundingBox];
			CGSize size = frame.size;
			bgBg.position = ccp(self.view.position.x, -(size.height / 2));		
			bg.position = bgBg.position;		

			[self.view addChild:bgBg z:-1];
			[self.view addChild:bg z:-1];

			[bg release];
			[bgBg release];
		}
	}
	
	return self;
}


-(void)createArrayOfMessagesToFitScreenWithMessage:(NSString*)msg
{
	float msgWidth = [msg sizeWithFont:[UIFont systemFontOfSize:fontSize]].width;
	
	//message will fit on screen
	if(msgWidth < bubbleSize.width)
	{
		[msgSubstringArray addObject:msg];
		
		NSArray *fullMsg = [initMessage componentsSeparatedByString:@" "];
		int subStringArrayWordCount = [[[msgSubstringArray componentsJoinedByString:@" "] componentsSeparatedByString:@" "]count];
		
		//if we haven't already taken the whole string - get the next bit
		if((subStringArrayWordCount < [fullMsg count]))
		{
			int nextRange = [fullMsg count] - subStringArrayWordCount;
			NSArray *nextArray = [fullMsg subarrayWithRange:NSMakeRange(subStringArrayWordCount, nextRange)];
			NSString *nextMsgPart = [nextArray componentsJoinedByString:@" "];
			[self createArrayOfMessagesToFitScreenWithMessage:nextMsgPart];	
		}		
	}
	
	//message won't fit the width of the screen - shorten it and try again
	else 
	{
		NSArray *fullMessage = [msg componentsSeparatedByString:@" "];
		int range = [fullMessage count] - 1;
		NSArray *subStringArray = [fullMessage subarrayWithRange:NSMakeRange(0, range)];
		NSString *subString = [subStringArray componentsJoinedByString:@" "];
		[self createArrayOfMessagesToFitScreenWithMessage:subString];		
	}	
}


-(void)addMessageComponents
{	
	float heightOfComponents = [initMessage sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].height;
	float initialYVal = -(heightOfComponents / 2);//totalHeight + (([[CCDirector sharedDirector]winSize].height - totalHeight) / 2);
	
	for(NSString *msgComponent in msgSubstringArray)
	{
		EZWord *lab = [[EZWord alloc]initWithString:msgComponent fntFile:@"Lucidia30.fnt"];
        
        NSLog(@"description: %@", [lab textureAtlas]);

		lab.position = ccp(0,initialYVal); 
		[self.view addChild:lab];
		[lab release];
		initialYVal -= heightOfComponents;
      
	}	
}


-(CGSize)calcWidthAndHeightOfMessage
{
	float maxWidth = 0;
	
	for(NSString *msgComponent in msgSubstringArray)
	{
		float currentWidth = [msgComponent sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].width;		
		maxWidth = currentWidth > maxWidth ? currentWidth : maxWidth;
	}
	
	float heightOfComponents = [initMessage sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].height;
	float totalHeight = heightOfComponents * [msgSubstringArray count];
	
	return CGSizeMake(maxWidth, totalHeight);	
}


-(void)dealloc
{
    [view release];
	[fontName release];
	[msgSubstringArray release];
	[initMessage release];
	[super dealloc];	
}


@end
