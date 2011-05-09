

#import "cocos2d.h"

@class EZPageView, EZWord;

//TODO: position works like anchorpoint is set at 0.5, 0.0 - fix it.

@interface EZTextViewController : CCLayer
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
}

@property(nonatomic, assign)EZPageView *page;

-(id)initWithPage:(EZPageView*)page;
-(int)stopIdx;
-(void)layoutWords;


@end
