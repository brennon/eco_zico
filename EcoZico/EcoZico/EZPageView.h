//
//  EZPageView.h
//  EcoZico
//
//  Created by Brennon Bortz and Donal O'Brien on 07/05/2011.
//  Copyright 2011 Queens University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZPageView : UIScrollView {
    id <UIScrollViewDelegate> delegate;
}

@property (nonatomic, assign) id <UIScrollViewDelegate> delegate;

- (void)setupBookWithNumberofPages:(NSUInteger)count withDelegate:(id <UIScrollViewDelegate>)svDelegate;

@end