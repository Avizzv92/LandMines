//
//  LMBlock.h
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "CCSprite.h"
#import "LMGridItem.h"

typedef enum {OccupantMine, OccupantHealth, OccupantTrampledGround, OccupantNone, OccupantExploded} Occupant;

@interface LMBlock : LMGridItem
{
    Occupant currentOccupant;
    int adjacentMineCount;
    BOOL isFlagged;
    CCSprite *flag;
}
@property(nonatomic, readwrite)Occupant currentOccupant;
@property(readwrite)int adjacentMineCount;
@property(readonly)BOOL isFlagged;

-(void)setCurrentOccupant:(Occupant)theCurrentOccupant;
-(void)flag;
-(void)detonate; 

@end
