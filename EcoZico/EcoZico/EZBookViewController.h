//
//  BookViewController.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "EZParagraphTransition.h"

#define PLAY_PAUSE_BUTTON_WIDTH 85

@class EZPage, EZTextViewScene, EZPageView, EZTextView, EZBook;


@interface EZBookViewController : UIViewController <UIScrollViewDelegate, AVAudioPlayerDelegate, EZParagraphTransitionDelegate> 
{
    IBOutlet    EZPageView  *ezPageView;
    IBOutlet    UIView      *textView;
    
                EZBook          *ezBook;    
                NSNumber        *currentPage;
        
                // TV vars //
    
                //TEMP - debug button for skipping paragraphs
                UIButton        *skipParaBut;
    
                BOOL            isFirstPageAfterLaunch;

                //cocos2d labels for words
                NSArray         *ezWordLabels;
                
                //cocos2d layer for drawing labels
                EZTextViewScene *ezTextViewScene;    
                
                // play pause button
                UIButton        *playPauseBut;
                
                // used to continuing laying out page text from the end of the last paragraph
                int             idxOfLastWordLaidOut;
                
                //audio player
                AVAudioPlayer   *player;
}

@property (nonatomic, retain) IBOutlet  EZPageView          *ezPageView;
@property (nonatomic, retain)           UIView              *textView;
@property (nonatomic, retain)           EZBook              *ezBook;
@property (nonatomic, retain)           NSNumber            *currentPage;

// TV properties
@property (nonatomic, retain)           NSArray             *ezWordLabels;
@property (nonatomic, retain)           EZTextViewScene     *ezTextViewScene;
@property (nonatomic, retain) IBOutlet  UIButton            *playPauseBut;
@property (nonatomic, retain)           AVAudioPlayer       *player;
@property int                                               idxOfLastWordLaidOut;
@property (nonatomic, retain) IBOutlet  UIButton            *skipParaBut; // debugging
@property (nonatomic, retain)           NSMutableArray      *touchZones;

//scroll view methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

//TV methods
-(void)attachCocos2dToSelf;

-(void)loadNewPage:(EZPage *)ezPage withTransition:(BOOL)withTrans;

-(void)layoutTextWithTransition:(BOOL)withTrans;

-(void)loadAudioForPage:(int)pageNum;

//play / pause audio playback (and TVC narration)
- (IBAction)playPause:(id)sender;

- (void)playAudio;

- (void)pauseAudio;

- (void)textViewDidFinishNarratingParagraph;

- (IBAction)skipPara:(id)sender; //debugging

- (void)playImageAudio:(id)sender;

@end
