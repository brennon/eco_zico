//
//  EZPageView.h
//  cocos2dTest
//
//  Created by Donal O'Brien on 07/05/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@class EZTextViewController;

@interface EZPageView : UIScrollView <AVAudioPlayerDelegate>
{
    //TEMP - for showing name of transitions
    UILabel *transitionLabel;
    
    //TEMP - play pause button
    UIButton *playPauseBut;
    
    //TEMP - debug button for skipping paragraphs
    UIButton *skipParaBut;
    
    //TEMP - debug
    int paraNum;
    
    // used to continuing laying out page text from the end of the last paragraph
    int idxOfLastWordLaidOut;
    
    // text for the page
    NSString *text;
    
    //EZWord objects
    NSArray *words;
    
    EZTextViewController *textVC;
}

@property(nonatomic, retain) IBOutlet UIButton *skipParaBut;
@property(nonatomic, retain) IBOutlet UIButton *playPauseBut;
@property(nonatomic, retain) IBOutlet UILabel *transitionLabel;
@property (nonatomic, retain) AVAudioPlayer *player;
@property(nonatomic, retain) NSArray *words;
@property(nonatomic, retain) NSString *text;
@property int idxOfLastWordLaidOut;


// create EZWord objs
-(NSArray*)createWordObjsFromText:(NSString*)str;

// create EZTextViewController and tell it to layout words. 
// cocos2d transitions are done here also.
-(void)layoutText;

// will be delegate method
-(void)textViewDidFinishNarratingParagraph;

-(void)loadAudioForPage:(int)pageNum;

//play / pause audio playback (and TVC narration)
-(IBAction)playPause:(id)sender;

//debugging
-(IBAction)skipPara:(id)sender;


@end
