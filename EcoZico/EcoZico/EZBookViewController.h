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

@class EZPage, EZTextViewScene, EZPageView, EZBook, EZAudioPlayer;

@interface EZBookViewController : UIViewController <UIScrollViewDelegate, AVAudioPlayerDelegate, EZParagraphTransitionDelegate>

@property (nonatomic, retain) IBOutlet  EZPageView          *ezPageView;
@property (nonatomic, retain) IBOutlet  UIButton            *playPauseBut;
@property (nonatomic, retain) IBOutlet  UIButton            *skipParaBut; // For debugging
@property (nonatomic, retain)           UIView              *textView;
@property (nonatomic, retain)           EZBook              *ezBook;
@property (nonatomic, retain)           NSNumber            *currentPage;
@property (nonatomic, retain)           NSArray             *ezWordLabels;
@property (nonatomic, retain)           EZTextViewScene     *ezTextViewScene;
@property (nonatomic, retain)           EZAudioPlayer       *ezAudioPlayer;
@property (nonatomic, assign)			NSUInteger			idxOfLastWordLaidOut;
@property (nonatomic, retain)           AVAudioPlayer       *player;
@property (nonatomic, retain)           NSMutableArray      *touchZones;
@property (nonatomic, assign)			BOOL				audioIsPlaying;
@property (nonatomic, assign)			BOOL				isFirstPageAfterLaunch;

- (void)attachCocos2dToSelf;
- (void)loadNewPage:(EZPage *)ezPage withTransition:(BOOL)withTrans; 
- (void)layoutTextWithTransition:(BOOL)withTrans;
- (void)loadAudioForPage:(int)pageNum;
- (IBAction)playPause:(id)sender; // Play/pause audio playback (and TVC narration)
- (void)playAudio;
- (void)pauseAudio;
- (void)playImageAudio:(id)sender;
- (void)textViewDidFinishNarratingParagraph;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
