//
//  LMSoldier.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMSoldier.h"
#import "LMGridManager.h"
#import "LMBlock.h"
#import "LMGameManager.h"
#import "cocos2d.h"
#import "LMMineSweeper.h"

@implementation LMSoldier

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(LMGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    
    if (self) 
    {        
        isPaused = NO;
        isMoving = NO;
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"allyWalk1.png"];
         
         CGSize size = texture.contentSize;
         CGRect rect;
         rect.size = size;
         rect.origin = ccp(0,0);
         [self setTexture:texture];
         [self setTextureRect:rect];
        
        CCTexture2D *walk1 = [[CCTextureCache sharedTextureCache] addImage:@"allyWalk1.png"];
        CCTexture2D *walk2 = [[CCTextureCache sharedTextureCache] addImage:@"allyWalk2.png"];

        CGSize size1 = walk1.contentSize;
        CGRect rect1;
        rect1.size = size1;
        rect1.origin = ccp(0,0);
        
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk1 rect:rect1] name:@"allyWalk1"];
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFrame:[CCSpriteFrame frameWithTexture:walk2 rect:rect1] name:@"allyWalk2"];
            }
    
    return self;
}

#pragma mark -
#pragma mark Movement Methods

-(void)moveAtSpeed:(float)speed
{
    if(isMoving)return;
    else isMoving = YES;
    
    NSMutableArray *allActions = [[NSMutableArray alloc]init];
    
    int adjustingY = self.position.y+kBlockSize;

    for(int i = 0; i <= kGridHeight+3; i++)
    {
        id moveN = [CCMoveTo actionWithDuration:speed position:CGPointMake(self.position.x,adjustingY)];
        [allActions addObject:[CCSequence actions:moveN,[CCCallFunc actionWithTarget:self selector:@selector(actionIsDone)],nil]];
        adjustingY += kBlockSize;
    }
                                  
    [self runAction:[CCSequence actionsWithArray:allActions]];
    
    [allActions release];
    
    NSMutableArray *runFrames = [[NSMutableArray alloc]init];
    [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"allyWalk1"]];
    [runFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"allyWalk2"]];

    CCAnimation * runAnim = [CCAnimation animationWithFrames:runFrames delay:.2f];
    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]]];
    [runFrames release];
}

-(void)actionIsDone
{
    CGPoint newLocation = CGPointMake(self.gridLocation.x, self.gridLocation.y + 1);
    self.gridLocation = newLocation;//If check was here for grid height
    int adjustedZ = ((kGridHeight - (self.gridLocation.y - 1)) - 1 >= 0 ) ? (kGridHeight - (self.gridLocation.y - 1))-1 : 0;
    
    if(CGPointEqualToPoint(self.gridLocation, self.gridManager.mineSweeper.gridLocation))adjustedZ--;
    
    [self.gridManager reorderChild:self z:adjustedZ];
    [self checkCurrentLocation];
}

-(void)checkCurrentLocation
{
    LMBlock *currentBlock = [self.gridManager blockForLocation:self.gridLocation];
    
    if(currentBlock != nil && currentBlock.currentOccupant == OccupantMine && currentBlock.isFlagged == NO)
    {
        [currentBlock detonate];
        [self steppedOnMine];
    }
}

-(void)steppedOnMine
{        
    [self stopAllActions];
    [self runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.4f],[CCCallFunc actionWithTarget:self selector:@selector(removeSelf)], nil]];
}

-(void)removeSelf
{
    int armyCount = [[gridManager getSoldiers]count];
    
    if(armyCount-1 == 4)[gridManager.gameManager gameOver];
    
    [self removeFromParentAndCleanup:YES];
    [[gridManager getSoldiers]removeObject:self];
}


-(void)reset
{
    isMoving = NO;
}

#pragma mark -
#pragma mark Game State Methods

-(void)pause
{
    isPaused = !isPaused;
}


@end
