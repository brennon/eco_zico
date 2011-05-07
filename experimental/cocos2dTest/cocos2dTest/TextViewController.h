

#import "cocos2d.h"

//TODO: position works like anchorpoint is set at 0.5, 0.0 - fix it.

@interface TextViewController : NSObject
{
    CCLayerColor *view;
	
	NSString *initMessage;
    NSArray *words;

}

@property(nonatomic, retain)NSArray *words;
@property (nonatomic, retain)CCLayerColor *view;
@property(nonatomic,retain)NSString *initMessage;

-(id)initWithText:(NSString*)text;
-(NSArray*)wordObjsForWordsInString:(NSString*)str;
-(void)layoutWords;


@end
