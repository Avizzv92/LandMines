//
//  LMGridItem.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMGridItem.h"
#import "LMGridManager.h"

@implementation LMGridItem
@synthesize gridLocation, gridManager;

#pragma mark -
#pragma mark Init Method

-(id)initWithOwningGrid:(LMGridManager *)theGrid;
{
    self = [super init];
    
    if(self != nil)
    {
        self.gridManager = theGrid;
    }
    
    return self;
}

@end
