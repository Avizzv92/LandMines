//
//  LMSoldier.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMSheep.h"
#import "LMGridManager.h"
#import "LMBlock.h"
#import "LMGameManager.h"
#import "cocos2d.h"

@implementation LMSheep

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(LMGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    
    if (self) 
    {        
        isPaused = NO;
        
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"sheep.png"];
         
         CGSize size = texture.contentSize;
         CGRect rect;
         rect.size = size;
         rect.origin = ccp(0,0);
         [self setTexture:texture];
         [self setTextureRect:rect];
        
        self.scale = 1.4f;
    }
    
    return self;
}

#pragma mark -
#pragma mark Movement Methods

-(void)moveAtSpeed:(float)speed
{
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
}

-(void)actionIsDone
{
    CGPoint newLocation = CGPointMake(self.gridLocation.x, self.gridLocation.y + 1);
    if(newLocation.y <= kGridHeight)self.gridLocation = newLocation;
    [self.gridManager reorderChild:self z:(kGridHeight - (self.gridLocation.y - 1))-1];
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
    [self removeFromParentAndCleanup:YES];
}

#pragma mark -
#pragma mark Game State Methods

-(void)pause
{
    isPaused = !isPaused;
}

@end
