//
//  LMGameManager.h
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMBlock.h"
#import "cocos2d.h"

@class LMGridManager;
@class LMCheatMenu;
@class LMGameMenus;

@interface LMGameManager : CCLayer
{
    LMGridManager *gridManager;
    int currentPhase;
    int totalCurrentMines;
    BOOL isPaused;
    int totalTimeRemaining;
    int totalGameTime;
    int totalFlags;
    
    CGPoint touchStartPoint;
    CGPoint touchSingleSwipeStartPoint;
    BOOL wasHeld;
    
    LMCheatMenu *cheatBox;
    
    CCLabelTTF *detectorReading;
    BOOL advanceCalled;
    
    LMGameMenus *gameMenus;
        
    int timePerBombing;
    int totalBombings;
}
@property(readwrite)int totalMines;
@property(readonly)BOOL advanceCalled;

-(void)loadGame;
-(void)advanceGame;

-(void)resetGame;
-(void)gameOver;
-(void)pause;

-(void)moveUp;
-(void)moveDown;
-(void)moveRight;
-(void)moveLeft;

-(void)setDetectorReading:(int)reading;

-(CGRect)rectForSprite:(LMBlock *)sprite;

-(int)getCurrentPhase;

@end
