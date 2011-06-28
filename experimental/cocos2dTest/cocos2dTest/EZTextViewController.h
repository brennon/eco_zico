

#import "cocos2d.h"


@class EZPageView, EZWord;

//TODO: position works like anchorpoint is set at 0.5, 0.0 - fix it.

@interface EZTextViewController : CCLayerColor 
{
    EZPageView *page;
    	    
    float heightOfWords;
    float inset;
    float padding;
    float incY;
    float x, y;
    BOOL startOFLine;
    CGSize s;
    float prevWordWidth;
    float currentWordWidth;
    EZWord *word;
    
    int idxEndOfline3;
    int idxStopPoint;
    
    //narration
    int wordPositionCounter;
    NSTimer *timer;
    EZWord *currentWord;
    NSTimeInterval currentPlaybackPosition;
    BOOL isParaNarrationFinished;
}

@property(nonatomic, assign)EZPageView *page;

-(id)initWithPage:(EZPageView*)page;

//find where to stop laying out words
-(int)stopIdx;

//layout words to idx found with stopIdx
-(void)layoutWords;

//callback when a para reaches end of narration
-(void)paraNarrationDidFinish;

//pause / resume timers (used for polling audio player position)
-(void)playPause;

//for debugging
-(void)setWordPositionForTime:(NSTimeInterval)time;


@end
