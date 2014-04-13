//
//  LMSoldier.h
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "CCSprite.h"
#import "LMGridItem.h"

@interface LMSheep : LMGridItem
{
    BOOL isPaused;
}

-(void)moveAtSpeed:(float)speed;
-(void)checkCurrentLocation;
-(void)steppedOnMine;

-(void)pause;

@end
