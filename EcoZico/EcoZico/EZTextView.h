//
//  EZTextView.h
//  EcoZico
//
//  Created by Brennon Bortz on 01/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EZTextView : UIView {
    NSString *text;
}

@property (nonatomic, retain) NSString *text;

- (void)attachCocos2dToSelf;

@end
