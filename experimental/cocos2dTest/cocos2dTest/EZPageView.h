//
//  EZPageView.h
//  cocos2dTest
//
//  Created by Donal O'Brien on 07/05/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EZPageView : UIScrollView 
{
    //TEMP - for showing name of transitions
    UILabel *transitionLabel;
    
    // used to continuing laying out page text from the end of the last paragraph
    int idxOfLastWordLaidOut;
    
    // text for the page
    NSString *text;
    
    //EZWord objects
    NSArray *words;
}

@property(nonatomic, retain)IBOutlet UILabel *transitionLabel;
@property(nonatomic, retain)NSArray *words;
@property(nonatomic, retain) NSString *text;
@property int idxOfLastWordLaidOut;

// create EZWord objs
-(NSArray*)createWordObjsFromText:(NSString*)str;

// create EZTextViewController and tell it to layout words. 
// cocos2d transitions are done here also.
-(void)layoutText;

// will be delegate method
-(void)textViewDidFinishNarratingParagraph;

@end
