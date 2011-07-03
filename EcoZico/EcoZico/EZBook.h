//
//  EZBook.h
//  EcoZico
//
//  Created by Brennon Bortz on 03/07/2011.
//  Copyright 2011 Queen's University Belfast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZBook : NSObject {
    NSArray *pages;    
}

@property (nonatomic, retain) NSArray *pages;

- (id)initWithPages:(NSArray *)pageArray;

@end
