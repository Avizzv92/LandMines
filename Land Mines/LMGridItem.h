//
//  LMGridItem.h
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "CCSprite.h"

@class LMGridManager;

@interface LMGridItem : CCSprite
{
    CGPoint gridLocation;
    LMGridManager *gridManager;
}
@property(readwrite)CGPoint gridLocation;
@property(nonatomic, assign)LMGridManager *gridManager;

-(id)initWithOwningGrid:(LMGridManager *)theGrid;

@end
