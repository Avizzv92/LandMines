//
//  LMGameManager.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMGameManager.h"
#import "LMGridManager.h"
#import "cocos2d.h"
#import "LMMineSweeper.h"
#import "LMSoldier.h"
#import "LMCheatMenu.h"
#import "LMGameMenus.h"
#import "LMAchievementManager.h"

#define kGameTick 1.0f
#define kSwipeDistance 45
#define kSwipeMarginOfError 75
#define kHoldMoveDelay .001
#define kMaxMines 60
#define kTimePerMine 30

@implementation LMGameManager
@synthesize totalMines,advanceCalled;

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
                
        gameMenus = [LMGameMenus node];
        gameMenus.gm = self;
        [self addChild:gameMenus z:20];
        
        gridManager = [[LMGridManager alloc]init];
        gridManager.gameManager = self;
        [self addChild:gridManager];
        
        isPaused = NO;
        
        [[CCScheduler sharedScheduler]scheduleSelector:@selector(gameTick:) forTarget:self interval:kGameTick paused:NO];
        
        wasHeld = NO;
        
        [self loadGame];
        
        cheatBox = [LMCheatMenu node];
        cheatBox.grid = gridManager;
        [self addChild:cheatBox];
        
        CCSprite *detector = [CCSprite spriteWithFile:@"detector.png"];
        detector.position = CGPointMake(27, 453);
        detector.scale = 1.5f;
        detector.opacity = 160.0f;
        [self addChild:detector];
        
        detectorReading = [CCLabelTTF labelWithString:@"0" fontName:@"DB LCD Temp" fontSize:30];
        detectorReading.position = CGPointMake(14, 462);
        detectorReading.opacity = 175.0f;
        [self addChild:detectorReading];
    }
    
    return self;
}

-(void)loadGame
{
    self.isTouchEnabled = YES;
    [self stopAllActions];
    [gridManager cancelBombing];

    totalTimeRemaining = 0;
    totalGameTime = 0;
    
    timePerBombing = 0;
    totalBombings = 0;
    
    currentPhase = 1;
    totalCurrentMines = 3;
    totalTimeRemaining = totalCurrentMines * 30;
    self.totalMines = 0;
    [gridManager loadGridWithMineCount:totalCurrentMines healthPackCount:0];
    advanceCalled = NO;
    [gameMenus showPhaseNumber:currentPhase];
}

#pragma mark -
#pragma mark Game Phase Management

-(void)advanceGame
{
    [gridManager cancelBombing];
    [gridManager.mineSweeper pause];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];
    self.isTouchEnabled = NO;
    
    advanceCalled = YES;
    [gridManager runAction:[CCSequence actions:[CCFadeTo actionWithDuration:.5f opacity:0.0f], [CCFadeTo actionWithDuration:.3f opacity:0.0f] ,[CCFadeTo actionWithDuration:.5f opacity:255.0f], nil]];
    [self performSelector:@selector(_advance) withObject:self afterDelay:.5f];
    
    [LMAchievementManager checkAchvForGrid:gridManager];
}

-(void)_advance
{
    currentPhase++;
    int healthPackCount = 0;
    totalFlags = 0;
    totalBombings = 0;
    
    if(currentPhase % 4 == 0)
    {
        totalCurrentMines++;
        int randomeIncrease = (arc4random() % 2);
        totalCurrentMines += randomeIncrease;
    }
    
    if(totalCurrentMines > kMaxMines)totalCurrentMines = kMaxMines;
    
    totalTimeRemaining = (totalCurrentMines * (30 - (currentPhase/10)));
    
    if(currentPhase >= 10)
    {
        totalBombings = totalCurrentMines / 8;
        totalBombings += (arc4random() % 2);
        totalBombings++; //Add one since the last one never gets called anyways since by then army is coming
    }
    
    timePerBombing = (totalTimeRemaining/totalBombings);
    
    [gameMenus showPhaseNumber:currentPhase];
    [gridManager advanceGridWithMineCount:totalCurrentMines healthPackCount:healthPackCount];
    advanceCalled= NO;
    
    self.isTouchEnabled = YES;
 }

-(void)gameTick:(ccTime)time
{
    totalTimeRemaining--;
    totalGameTime++;
    
    if(totalTimeRemaining == 0)
    {
        [gridManager autoMoveArmy];
    }
    
    LMSoldier *testSoldier = [[gridManager getSoldiers]lastObject];
    if(testSoldier.gridLocation.y >= 14 && !advanceCalled)
    {
        [self advanceGame];
    }
    
    if((currentPhase > 10) && totalGameTime > 0 && (timePerBombing * totalBombings) != totalGameTime && (totalGameTime % timePerBombing == 0))[gridManager sendBomber];
}

#pragma mark -
#pragma mark touch methods 
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    touchStartPoint = point;
    touchSingleSwipeStartPoint = point;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
        
    if(abs(point.y - touchStartPoint.y) >= kSwipeDistance && point.y < touchStartPoint.y && abs(point.x - touchStartPoint.x) <= kSwipeMarginOfError)
    {
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];
        
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveUp) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveUp) forTarget:self interval:kHoldMoveDelay paused:NO];
        touchStartPoint = point;
    }
    
    else if(abs(point.y - touchStartPoint.y) >= kSwipeDistance && point.y > touchStartPoint.y && abs(point.x - touchStartPoint.x) <= kSwipeMarginOfError)
    {
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];
        
        
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveDown) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveDown) forTarget:self interval:kHoldMoveDelay paused:NO];
        touchStartPoint = point;
    }
    
    else if(abs(point.x - touchStartPoint.x) >= kSwipeDistance && point.x > touchStartPoint.x && abs(point.y - touchStartPoint.y) <= kSwipeMarginOfError)
    {
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];
        
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveRight) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveRight) forTarget:self interval:kHoldMoveDelay paused:NO];
        touchStartPoint = point;
    }
    
    else if(abs(point.x - touchStartPoint.x) >= kSwipeDistance && point.x < touchStartPoint.x && abs(point.y - touchStartPoint.y) <= kSwipeMarginOfError)
    {
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
        
        if(![[CCScheduler sharedScheduler]isScheduled:@selector(moveLeft) forTarget:self])[[CCScheduler sharedScheduler]scheduleSelector:@selector(moveLeft) forTarget:self interval:kHoldMoveDelay paused:NO];
        touchStartPoint = point;
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];
    
    if(abs(point.y - touchSingleSwipeStartPoint.y) >= kSwipeDistance && point.y < touchSingleSwipeStartPoint.y && abs(point.x - touchSingleSwipeStartPoint.x) <= kSwipeMarginOfError)
    {
        if(!wasHeld)[self moveUp];
        wasHeld = NO;
        return;
    }
    
    else if(abs(point.y - touchSingleSwipeStartPoint.y) >= kSwipeDistance && point.y > touchSingleSwipeStartPoint.y && abs(point.x - touchSingleSwipeStartPoint.x) <= kSwipeMarginOfError)
    {
        if(!wasHeld)[self moveDown];
        wasHeld = NO;
        return;
    }
    
    else if(abs(point.x - touchSingleSwipeStartPoint.x) >= kSwipeDistance && point.x > touchSingleSwipeStartPoint.x && abs(point.y - touchSingleSwipeStartPoint.y) <= kSwipeMarginOfError)
    {
        if(!wasHeld)[self moveRight];
        wasHeld = NO;
        return;
    }
    
    else if(abs(point.x - touchSingleSwipeStartPoint.x) >= kSwipeDistance && point.x < touchSingleSwipeStartPoint.x && abs(point.y - touchSingleSwipeStartPoint.y) <= kSwipeMarginOfError)
    {
        if(!wasHeld)[self moveLeft];
        wasHeld = NO;
        return;
    }
    
    if([[event allTouches]count]==2)[gridManager callArmy];
    
    if([touch tapCount]==2)[self pause];
    
    for(LMBlock *block in [gridManager getBlocks])
    {
        CGPoint convertedPoint = [self convertTouchToNodeSpace:[touches anyObject]];        
        CGRect blockRect = [self rectForSprite:block];
    
        if(CGRectContainsPoint(blockRect,convertedPoint))
        {
            int x = block.gridLocation.x;
            int y = block.gridLocation.y;
            
            if((gridManager.mineSweeper.gridLocation.x + 1 == x && gridManager.mineSweeper.gridLocation.y + 1 == y) ||
               (gridManager.mineSweeper.gridLocation.x - 1 == x && gridManager.mineSweeper.gridLocation.y - 1 == y) ||
               (gridManager.mineSweeper.gridLocation.x + 1 == x && gridManager.mineSweeper.gridLocation.y - 1 == y) ||
               (gridManager.mineSweeper.gridLocation.x - 1 == x && gridManager.mineSweeper.gridLocation.y + 1 == y) ||
               (gridManager.mineSweeper.gridLocation.x + 1 == x && gridManager.mineSweeper.gridLocation.y == y) ||
               (gridManager.mineSweeper.gridLocation.x - 1 == x && gridManager.mineSweeper.gridLocation.y == y) ||
               (gridManager.mineSweeper.gridLocation.x == x && gridManager.mineSweeper.gridLocation.y - 1 == y) ||
               (gridManager.mineSweeper.gridLocation.x == x && gridManager.mineSweeper.gridLocation.y + 1 == y))
            {
                if(block.isFlagged)
                {
                    if(totalFlags > 0)totalFlags--;
                    [block flag];
                }
                
                else 
                {
                    if(totalFlags < totalCurrentMines)
                    {
                        totalFlags++;
                        [block flag];
                    }
                }
            }
            
        }
    }
}

#pragma mark -
#pragma mark gameplay control methods 

-(void)moveUp
{
    wasHeld = YES;
    [gridManager.mineSweeper move:North];
}

-(void)moveDown
{
    wasHeld = YES;
    [gridManager.mineSweeper move:South];
}

-(void)moveRight
{
    wasHeld = YES;
    [gridManager.mineSweeper move:East];
}

-(void)moveLeft
{
    wasHeld = YES;
    [gridManager.mineSweeper move:West];
}


#pragma mark -
#pragma mark Game State Methods
 
-(void)resetGame
{
    [self loadGame];
}

-(void)gameOver
{
    [LMAchievementManager checkAchvForGrid:gridManager];
    
    [gridManager.mineSweeper pause];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
    [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];
    self.isTouchEnabled = NO;
    
    [gameMenus showGameOver];
}

-(void)pause
{
    isPaused = !isPaused;
    
    [gridManager pause];
    
    if(isPaused)
    {
        [gridManager.mineSweeper pause];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveUp) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveDown) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveRight) forTarget:self];
        [[CCScheduler sharedScheduler]unscheduleSelector:@selector(moveLeft) forTarget:self];
        self.isTouchEnabled = NO;
        
        [gameMenus showPauseMenu];
    }
    
    else self.isTouchEnabled = YES;
}


-(CGRect)rectForSprite:(LMBlock *)sprite
{
	float h = [sprite contentSize].height;
	float w = [sprite contentSize].width;
	float x = sprite.position.x - w/2;
	float y = sprite.position.y - h/2;
	CGRect rect = CGRectMake(x,y,w,h);
	return rect;
}

-(int)getCurrentPhase
{
    return currentPhase;
}

#pragma mark -
#pragma mark UI Methods

-(void)setDetectorReading:(int)reading
{
    [detectorReading setString:[NSString stringWithFormat:@"%i",reading]]; 
}

#pragma mark -
#pragma mark Accelerometer Methods

#define kShakeCheat 1.5f

-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
 	if(acceleration.x > kShakeCheat)
    {
        [cheatBox show];
    }
}

#pragma mark -
#pragma mark Cleanup

-(void)dealloc
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [gridManager release];
    [super dealloc];
}

@end
