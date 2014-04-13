//
//  LMMineSweeper.h
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "CCSprite.h"
#import "LMGridItem.h"
#import "cocos2d.h"

typedef enum{North, South, East, West}Direction;

@interface LMMineSweeper : LMGridItem
{
    BOOL isPaused;
    int health;
    BOOL actionDone;
    Direction lastDirection;
}
@property(readwrite)int health;

-(void)moveToDefaultPosition;

-(void)move:(Direction)theDirection;
-(void)animateInDirection:(Direction)theDirection;
-(void)stopMovementAnimation;
-(void)actionIsDone;

-(void)checkCurrentLocation;

-(void)steppedOnMine;
-(void)flagLocation;
-(void)callArmy;
-(void)loseHealth;

-(void)pause;

@end
