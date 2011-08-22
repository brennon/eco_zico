//
//  BookViewController.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 21/04/2011.
//  Copyright 2011 Brennon Bortz and Donal O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "EZParagraphTransitions.h"

#define PLAY_PAUSE_BUTTON_WIDTH 85

@class EZPage, EZTextViewScene, EZPageView, EZTextView, EZBook, EZAudioPlayer;

@interface EZBookViewController : UIViewController <UIScrollViewDelegate, AVAudioPlayerDelegate, EZParagraphTransitionDelegate> 

@property (nonatomic, retain) IBOutlet  EZPageView          *ezPageView;
@property (nonatomic, retain)           UIView              *textView;
@property (nonatomic, retain)           EZBook              *ezBook;
@property (nonatomic, retain)           NSNumber            *currentPage;

// TV properties
@property (nonatomic, retain)           NSArray             *ezWordLabels;
@property (nonatomic, retain)           EZTextViewScene     *ezTextViewScene;
@property (nonatomic, retain) IBOutlet  UIButton            *playPauseBut;
@property (nonatomic, retain)           EZAudioPlayer       *ezAudioPlayer;
@property (nonatomic, assign)			int					idxOfLastWordLaidOut;
@property (nonatomic, retain) IBOutlet  UIButton            *skipParaBut; // debugging
@property (nonatomic, retain)           NSMutableArray      *touchZones;
@property (nonatomic, assign)			BOOL				audioIsPlaying;
@property (nonatomic, assign)			BOOL				isFirstPageAfterLaunch;

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
