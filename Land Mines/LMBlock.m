//
//  LMBlock.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMBlock.h"
#import "cocos2d.h"
#import "LMGridManager.h"
#import "SmokeSystem.h"
#import "ParticleExplosion.h"
#import "SimpleAudioEngine.h"
#import "LMMineSweeper.h"
#import "GlobalManager.h"
#import "LMGameManager.h"

@implementation LMBlock
@synthesize currentOccupant, adjacentMineCount, isFlagged;

#pragma mark -
#pragma mark Init Method

- (id)initWithOwningGrid:(LMGridManager *)theGrid
{
    self = [super initWithOwningGrid:theGrid];
    
    if (self) 
    {        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"block.png"];
                
        flag = [CCSprite spriteWithFile:@"flag.png"];
        flag.opacity = 0.0f;
        flag.position = CGPointMake(kBlockSize/2, (kBlockSize/2)+kBlockSize);
        [self addChild:flag];
        
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
        
        isFlagged = NO;
        
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"Explosion.wav"];
        
    }
    
    return self;
}

#pragma mark -
#pragma mark State Change Methods

-(void)setCurrentOccupant:(Occupant)theCurrentOccupant
{
    //Upadte Graphics
    currentOccupant = theCurrentOccupant;
    
    if(currentOccupant == OccupantMine)
    {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"block.png"];
        
        CGSize size = texture.contentSize;
        CGRect rect;
        rect.size = size;
        rect.origin = CGPointMake(0,0);
        [self setTexture:texture];
        [self setTextureRect:rect];
    }
    
    else if(currentOccupant == OccupantNone)
    {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"block.png"];
        
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
    }
    
    else if(currentOccupant == OccupantExploded)
    {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"hole.png"];
        
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
    }
    
    else if(currentOccupant == OccupantTrampledGround)
    {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"trampled.png"];
        
		CGSize size = texture.contentSize;
		CGRect rect;
		rect.size = size;
		rect.origin = ccp(0,0);
		[self setTexture:texture];
		[self setTextureRect:rect];
    }
    
    else if(currentOccupant == OccupantHealth)
    {
        
    }
}

-(void)flag
{    
    [flag setTexture:[[CCTextureCache sharedTextureCache]addImage:[[GlobalManager sharedManager]getFlagType]]];
    
    if(!isFlagged)
    {
        isFlagged = YES;
        
        id move = [CCMoveTo actionWithDuration:.3f position:CGPointMake(flag.position.x, flag.position.y - kBlockSize)];
        id fade = [CCFadeTo actionWithDuration:.3f opacity:255.0f];
        [flag runAction:move];
        [flag runAction:fade];
        
        if(self.currentOccupant == OccupantMine)self.gridManager.gameManager.totalMines++;
    }
    
    else
    {
        [flag runAction:[CCFadeOut actionWithDuration:.3f]];
        [flag runAction:[CCMoveTo actionWithDuration:.3f position:CGPointMake(kBlockSize/2, (kBlockSize/2)+kBlockSize)]];
        
        isFlagged = NO;
        
        if(self.currentOccupant == OccupantMine)self.gridManager.gameManager.totalMines--;
    }
    
}

-(void)detonate
{
    [self setCurrentOccupant:OccupantExploded];
    [self.gridManager setAdjacentMineCounts];
     
    [[SimpleAudioEngine sharedEngine]playEffect:@"Explosion.wav"];
	AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
	
	//Creates a particle blast effect
    ParticleExplosion *exp = [ParticleExplosion node];
    exp.position = CGPointMake(self.position.x,self.position.y-5);//CGPointMake(kBlockSize/2, kBlockSize/2);
	[self.parent addChild:exp z:9];
	
	//Creates a post blast smoke effect
	SmokeSystem *smk = [SmokeSystem node];
    smk.position = CGPointMake(self.position.x,self.position.y-5);//CGPointMake(kBlockSize/2, kBlockSize/2);
	[self.parent addChild:smk z:10];
} 

-(void)dealloc
{
    [[SimpleAudioEngine sharedEngine]unloadEffect:@"Explosion.wav"];
    [super dealloc];
}

@end
