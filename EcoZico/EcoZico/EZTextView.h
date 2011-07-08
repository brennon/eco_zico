//
//  EZTextView.h
//  EcoZico
//
//  Created by Brennon Bortz on 01/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@class EZPage, EZTextViewScene;

@interface EZTextView : UIView {
    NSArray *ezWordLabels;
    EZTextViewScene *ezTextViewScene;
    
    
    /*** BEGIN NEED TO CULL ***/
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
    /*** END NEED TO CULL ***/
}

@property (nonatomic, retain) NSArray *ezWordLabels;
@property (nonatomic, retain) EZTextViewScene *ezTextViewScene;

/*** BEGIN NEED TO CULL ***/
@property(nonatomic, retain) IBOutlet UIButton *skipParaBut;
@property(nonatomic, retain) IBOutlet UIButton *playPauseBut;
@property(nonatomic, retain) IBOutlet UILabel *transitionLabel;
@property (nonatomic, retain) AVAudioPlayer *player;
@property int idxOfLastWordLaidOut;
/*** END NEED TO CULL ***/

- (void)attachCocos2dToSelf;
- (void)loadNewPage:(EZPage *)ezPage;

/*** BEGIN NEED TO CULL ***/
// will be delegate method
-(void)textViewDidFinishNarratingParagraph;
-(void)loadAudioForPage:(int)pageNum;
//play / pause audio playback (and TVC narration)
-(IBAction)playPause:(id)sender;
//debugging
-(IBAction)skipPara:(id)sender;
/*** END NEED TO CULL ***/

@end
