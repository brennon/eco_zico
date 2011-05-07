

#import "cocos2d.h"

//TODO: position works like anchorpoint is set at 0.5, 0.0 - fix it.

@interface TextViewController : NSObject
{
    CCNode *view;
	
	NSString *initMessage;
	NSMutableArray *msgSubstringArray;
	CGSize bubbleSize;
	float fontSize;
	CCSprite *bg;
	
	NSString *fontName;
	ccColor3B fontColour;
}

@property (nonatomic, retain)CCNode *view;

@property(nonatomic, retain)NSString *fontName;
@property ccColor3B fontColour;
@property CGSize bubbleSize;
@property(nonatomic,retain)NSString *initMessage;

-(id)initWithMessage:(NSString*)message size:(CGSize)s fontSize:(float)fntSize background:(BOOL)background fontName:(NSString*)fntName fontColour:(ccColor3B)fntColour;
-(id)initWithMessage:(NSString*)message size:(CGSize)s fontSize:(float)fntSize background:(BOOL)background;
-(void)createArrayOfMessagesToFitScreenWithMessage:(NSString*)msg;
-(void)addMessageComponents;
-(CGSize)calcWidthAndHeightOfMessage;

@end
