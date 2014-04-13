//
//  LMMineSweeper.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMMineSweeper.h"
#import "LMGridManager.h"
#import "LMBlock.h"
#import "LMGameManager.h"
#import "cocos2d.h"

#define kAnimationSpeed .2f

@implementation LMMineSweeper
@synthesize health;

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(LMGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    
    if (self) 
    {        
        isPaused = NO;
        health = 3;
        lastDirection = North;
        
        actionDone = YES;
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperN.png"];
         
        CGSize size = texture.contentSize;
        CGRect rect;
        rect.size = size;
        rect.origin = CGPointMake(0,0);
        [self setTexture:texture];
        [self setTextureRect:rect];
        
        CCTexture2D *walk1 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperN.png"];
        CCTexture2D *walk2 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperN1.png"];
        CCTexture2D *walk3 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperN2.png"];
        CCTexture2D *walk4 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperS.png"];
        CCTexture2D *walk5 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperS1.png"];
        CCTexture2D *walk6 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperS2.png"];
        CCTexture2D *walk7 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperE.png"];
        CCTexture2D *walk8 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperE1.png"];
        CCTexture2D *walk9 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperE2.png"];
        CCTexture2D *walk10 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperW.png"];
        CCTexture2D *walk11 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperW1.png"];
        CCTexture2D *walk12 = [[CCTextureCache sharedTextureCache] addImage:@"MinesweeperW2.png"];
        
        CGSize size1 = walk1.contentSize;
        CGRect rect1;
        rect1.size = size1;
        rect1.origin = ccp(0,0);
        
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk1 rect:rect1] name:@"MinesweeperN"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk2 rect:rect1] name:@"MinesweeperN1"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk3 rect:rect1] name:@"MinesweeperN2"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk4 rect:rect1] name:@"MinesweeperS"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk5 rect:rect1] name:@"MinesweeperS1"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk6 rect:rect1] name:@"MinesweeperS2"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk7 rect:rect1] name:@"MinesweeperE"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk8 rect:rect1] name:@"MinesweeperE1"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk9 rect:rect1] name:@"MinesweeperE2"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk10 rect:rect1] name:@"MinesweeperW"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk11 rect:rect1] name:@"MinesweeperW1"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk12 rect:rect1] name:@"MinesweeperW2"];
    }
    
    return self;
}

-(void)moveToDefaultPosition
{
    self.gridLocation = CGPointMake((int)(kGridWidth/2)+1, 0);
    self.position = [self.gridManager positionForLocation:self.gridLocation];
    self.position = CGPointMake(self.position.x, self.position.y + (kBlockSize/2));
    [self.gridManager reorderChild:self z:(kGridHeight - (self.gridLocation.y - 1))-1];
    [self move:North];
}

#pragma mark -
#pragma mark Movement Methods

-(void)move:(Direction)theDirection
{
    if(!actionDone)return;

    id moveN = nil;
    
    [self animateInDirection:theDirection];
    lastDirection = theDirection;
     
    if(theDirection == North)
    {
        CGPoint newLocation = CGPointMake(self.gridLocation.x, self.gridLocation.y + 1);
        
        if(newLocation.x <= 0 || newLocation.y <= 0 || newLocation.x > kGridWidth || newLocation.y > kGridHeight)
        {
            [self actionIsDone];
            return;
        }
        
        moveN = [CCMoveTo actionWithDuration:.4 position:CGPointMake(self.position.x,self.position.y+kBlockSize)];
        self.gridLocation = CGPointMake(self.gridLocation.x, self.gridLocation.y+1);
    }
    
    else if(theDirection == South)
    {
        CGPoint newLocation = CGPointMake(self.gridLocation.x, self.gridLocation.y - 1);
        if(newLocation.x <= 0 || newLocation.y <= 0 || newLocation.x > kGridWidth || newLocation.y > kGridHeight)
        {
            [self actionIsDone];
            return;
        }
        
        moveN = [CCMoveTo actionWithDuration:.4 position:CGPointMake(self.position.x,self.position.y-kBlockSize)];
        self.gridLocation = CGPointMake(self.gridLocation.x, self.gridLocation.y-1);
        [self.gridManager reorderChild:self z:(kGridHeight - (self.gridLocation.y - 1))-1];
    }
    
    else if(theDirection == East)
    {
        CGPoint newLocation = CGPointMake(self.gridLocation.x + 1, self.gridLocation.y);
        if(newLocation.x <= 0 || newLocation.y <= 0 || newLocation.x > kGridWidth || newLocation.y > kGridHeight)
        {
            [self actionIsDone];
            return;
        }

        moveN = [CCMoveTo actionWithDuration:.4 position:CGPointMake(self.position.x+kBlockSize,self.position.y)];
        self.gridLocation = CGPointMake(self.gridLocation.x+1, self.gridLocation.y);
    }
    
    else if(theDirection == West)
    {
        CGPoint newLocation = CGPointMake(self.gridLocation.x - 1, self.gridLocation.y);
        if(newLocation.x <= 0 || newLocation.y <= 0 || newLocation.x > kGridWidth || newLocation.y > kGridHeight)
        {
            [self actionIsDone];
            return;
        }
         
        moveN = [CCMoveTo actionWithDuration:.4 position:CGPointMake(self.position.x-kBlockSize,self.position.y)];
        self.gridLocation = CGPointMake(self.gridLocation.x-1, self.gridLocation.y);
    }
    
    actionDone = NO;
    
    [self runAction:[CCSequence actions:moveN, [CCCallFunc actionWithTarget:self selector:@selector(actionIsDone)], nil]];
}

-(void)actionIsDone
{
    actionDone = YES;
    [self stopMovementAnimation];
    [self checkCurrentLocation]; 
    [self.gridManager reorderChild:self z:(kGridHeight - (self.gridLocation.y - 1))-1];
}

-(void)checkCurrentLocation
{
    LMBlock *currentBlock = [self.gridManager blockForLocation:self.gridLocation];
    [self.gridManager.gameManager setDetectorReading:currentBlock.adjacentMineCount];

    if(currentBlock.currentOccupant == OccupantMine && ![currentBlock isFlagged])
    {
        [currentBlock detonate];
        [self steppedOnMine];
    }
    
    else if(currentBlock.currentOccupant == OccupantHealth)
    {
        currentBlock.currentOccupant = OccupantNone;
    }
    
    else if(currentBlock.currentOccupant == OccupantNone)
    {
        currentBlock.currentOccupant = OccupantTrampledGround;
    }
}

-(void)animateInDirection:(Direction)theDirection
{
    if(theDirection == North)
    {
        NSMutableArray *runFrames = [[NSMutableArray alloc]init];
        [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MinesweeperN1"]];
        [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MinesweeperN2"]];
        
        CCAnimation * runAnim = [CCAnimation animationWithFrames:runFrames delay:kAnimationSpeed];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]]];
        [runFrames release];
    }
    
    else if(theDirection == South)
    {
        NSMutableArray *runFrames = [[NSMutableArray alloc]init];
        [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MinesweeperS1"]];
        [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MinesweeperS2"]];
        
        CCAnimation * runAnim = [CCAnimation animationWithFrames:runFrames delay:kAnimationSpeed];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]]];
        [runFrames release];
    }
    
    else if(theDirection == East)
    {
        NSMutableArray *runFrames = [[NSMutableArray alloc]init];

        [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MinesweeperE1"]];
        [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MinesweeperE2"]];
        
        CCAnimation * runAnim = [CCAnimation animationWithFrames:runFrames delay:kAnimationSpeed];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]]];
        [runFrames release];
    }
    
    else if(theDirection == West)
    {
        NSMutableArray *runFrames = [[NSMutableArray alloc]init];
        [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MinesweeperW1"]];
        [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"MinesweeperW2"]];
        
        CCAnimation * runAnim = [CCAnimation animationWithFrames:runFrames delay:kAnimationSpeed];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]]];
        [runFrames release];
    }
}

-(void)stopMovementAnimation
{
    [self stopAllActions];
    
    if(lastDirection == North)
    {
        [self setTexture:[[CCTextureCache sharedTextureCache]addImage:@"MinesweeperN.png"]];
    }
    
    else if(lastDirection == South)
    {
        [self setTexture:[[CCTextureCache sharedTextureCache]addImage:@"MinesweeperS.png"]];
    }
    
    else if(lastDirection == East)
    {
        [self setTexture:[[CCTextureCache sharedTextureCache]addImage:@"MinesweeperE.png"]];
    }
    
    else if(lastDirection == West)
    {
        [self setTexture:[[CCTextureCache sharedTextureCache]addImage:@"MinesweeperW.png"]];
    }
}

#pragma mark -
#pragma mark Action Methods

-(void)steppedOnMine
{
    //Animation
    [self loseHealth];
    [self checkCurrentLocation]; 
}

-(void)flagLocation
{
    LMBlock *currentBlock = [self.gridManager blockForLocation:self.gridLocation];
    [currentBlock flag];
}

-(void)callArmy
{
    [gridManager callArmy];
}

-(void)loseHealth
{
    health--;
    
    if(health <= 0)
    {
        [self.gridManager.gameManager gameOver];
        [self runAction:[CCFadeOut actionWithDuration:.3f]];
    }
    
    else
    {
        id fade1 = [CCFadeOut actionWithDuration:.2f];
        id fade2 = [CCFadeIn actionWithDuration:.2f];
        [self runAction:[CCSequence actions:fade1, fade2, nil]];
    }
}

#pragma mark -
#pragma mark Game State Methods

-(void)pause
{
    actionDone = YES;
    [self stopAllActions];
    //isPaused = !isPaused;
}

@end
