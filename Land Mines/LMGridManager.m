//
//  LMGridManager.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMGridManager.h"
#import "LMMineSweeper.h"
#import "LMBlock.h"
#import "LMSoldier.h"
#import "LMSheep.h"
#import "SimpleAudioEngine.h"
#import "LMGameManager.h"
#import "ParticleExplosion.h"
#import "SmokeSystem.h"

#define kMineSweeperZ 2
#define kSoldierZ 2
#define kBlockZ 0
#define kPlaneTag 12

@implementation LMGridManager
@synthesize gameManager, mineSweeper;

#pragma mark -
#pragma mark Init Method

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        bg = [CCSprite spriteWithFile:@"BG_Sand.png"];
        [self addChild:bg];
        bg.position = CGPointMake(160,240);
        
        isPaused = NO;
        
        blocks = [[CCArray alloc]init];
        soldiers = [[CCArray alloc]init];
        
        LMMineSweeper *tempMineSweeper = [[LMMineSweeper alloc]initWithOwningGrid:self];
        self.mineSweeper = tempMineSweeper;
        [tempMineSweeper release];
        
        self.mineSweeper.gridLocation = CGPointMake((int)(kGridWidth/2)+1, 1);
        self.mineSweeper.position = [self positionForLocation:self.mineSweeper.gridLocation];
        self.mineSweeper.position = CGPointMake(self.mineSweeper.position.x, self.mineSweeper.position.y + (kBlockSize/2));
        [self addChild:self.mineSweeper z:kMineSweeperZ];
        
        sp = [LMSceneryProducer node];
        [self addChild:sp];
        
        allBomberActions = [[NSMutableArray alloc]init];
        
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"military.mp3" loop:YES];
    }
    
    return self;
}

#pragma mark -
#pragma mark Grid Setup Method

-(void)loadGridWithMineCount:(int)mineCount healthPackCount:(int)healthCount
{  
    [bg setTexture:[[CCTextureCache sharedTextureCache] addImage:@"BG_Sand.png"]];
    
    //Remove Old Scenery
    NSMutableArray *spritesToRemove = [[NSMutableArray alloc]init];
    for(CCSprite *sprite in self.children)
        if(sprite.tag >= kSceneryTagStartNum)[spritesToRemove addObject:sprite];
    for(CCSprite *sprite in spritesToRemove)[self removeChild:sprite cleanup:YES];
    [spritesToRemove release];
    //
    [sp placeSceneryAndFogAllowed:NO];
    
    self.mineSweeper.gridLocation = CGPointMake((int)(kGridWidth/2)+1, 1);
    self.mineSweeper.position = [self positionForLocation:self.mineSweeper.gridLocation];
    self.mineSweeper.position = CGPointMake(self.mineSweeper.position.x, self.mineSweeper.position.y + (kBlockSize/2));
    [self.mineSweeper setOpacity:255.0f];
    self.mineSweeper.health = 3;
    
    for(LMBlock *block in blocks)[block removeFromParentAndCleanup:YES];
    for(LMSoldier *soldier in soldiers)[soldier removeFromParentAndCleanup:YES];
    [blocks removeAllObjects];
    [soldiers removeAllObjects];
    
    [mineSweeper moveToDefaultPosition];

    int x = 1;
    int y = 1;
    
    for(int i = 0; i < (kGridWidth * kGridHeight); i++)
    {
        LMBlock *newBlock = [[LMBlock alloc]initWithOwningGrid:self];
        newBlock.gridLocation = CGPointMake(x, y);
        newBlock.position = [self positionForLocation:newBlock.gridLocation];
        newBlock.currentOccupant = OccupantNone;
        [self addChild:newBlock z:kBlockZ];
        [blocks addObject:newBlock];
        [newBlock release];
        
        if(x == kGridWidth)
        {
            x = 1;
            
            y++;
        }
        
        else
            x++;
    }
    
    [self placeMines:mineCount];
    [self placeHealthPakcs:healthCount];
    [self placeArmy];
}

-(void)advanceGridWithMineCount:(int)mineCount healthPackCount:(int)healthCount
{
    //Remove Old Scenery
    NSMutableArray *spritesToRemove = [[NSMutableArray alloc]init];
    for(CCSprite *sprite in self.children)
        if(sprite.tag >= kSceneryTagStartNum)[spritesToRemove addObject:sprite];
    for(CCSprite *sprite in spritesToRemove)[self removeChild:sprite cleanup:YES];
    [spritesToRemove release];
    //
    
    if([self.gameManager getCurrentPhase] == 4)[bg setTexture:[[CCTextureCache sharedTextureCache] addImage:@"BG_Trans.png"]];
    if([self.gameManager getCurrentPhase] >= 5)[bg setTexture:[[CCTextureCache sharedTextureCache] addImage:@"BG_Grass.png"]]; 
    
    for(LMBlock *block in blocks)[block removeFromParentAndCleanup:YES];
    [blocks removeAllObjects];
    
    [mineSweeper moveToDefaultPosition];
    
    int x = 1;
    int y = 1;
    
    for(int i = 0; i < (kGridWidth * kGridHeight); i++)
    {
        LMBlock *newBlock = [[LMBlock alloc]initWithOwningGrid:self];
        newBlock.gridLocation = CGPointMake(x, y);
        newBlock.position = [self positionForLocation:newBlock.gridLocation];
        newBlock.currentOccupant = OccupantNone;
        [self addChild:newBlock z:kBlockZ];
        [blocks addObject:newBlock];
        [newBlock release];
        
        if(x == kGridWidth)
        {
            x = 1;
            
            y++;
        }
        
        else
            x++;
    }
    
    [self placeMines:mineCount];
    [self placeHealthPakcs:healthCount];
    
    bool fog = ([self.gameManager getCurrentPhase] > 5) ? YES : NO;
    [sp placeSceneryAndFogAllowed:fog];
    
    for(LMSoldier *soldier in soldiers)
    {
        [soldier stopAllActions];
        soldier.gridLocation = CGPointMake(soldier.gridLocation.x, -2);
        soldier.position = [self positionForLocation:soldier.gridLocation];
        soldier.position = CGPointMake(soldier.position.x, soldier.position.y + (kBlockSize/2));
        [soldier reset];
    }
}

-(void)placeArmy
{
    int x = 1;
    int y = -2;
    
    for(int i = 0; i < kGridWidth; i++)
    {
        LMSoldier *newSoldier = [[LMSoldier alloc]initWithOwningGrid:self];
        newSoldier.gridLocation = CGPointMake(x, y);
        newSoldier.position = [self positionForLocation:newSoldier.gridLocation];
        newSoldier.position = CGPointMake(newSoldier.position.x, newSoldier.position.y + (kBlockSize/2));
        [self addChild:newSoldier z:kSoldierZ];
        [soldiers addObject:newSoldier];
        [newSoldier release];
        
        x++;
    }
}

-(void)placeMines:(int)mineCount
{
    for(int i = 0; i < mineCount; i++)
    {
        CGPoint randomLocation = [self getRandomGridLocation];
        [[self blockForLocation:randomLocation]setCurrentOccupant:OccupantMine];
    }
    
    [self setAdjacentMineCounts];
}

-(void)placeHealthPakcs:(int)healthPackCount
{
    for(int i = 0; i < healthPackCount; i++)
    {
        CGPoint randomLocation = [self getRandomGridLocation];
        [[self blockForLocation:randomLocation]setCurrentOccupant:OccupantHealth];
    }
}

-(void)setAdjacentMineCounts
{
    for(LMBlock *block in blocks)
    {
        int mineCount = 0;
        
        LMBlock *block1 = [self blockForLocation:CGPointMake(block.gridLocation.x + 1, block.gridLocation.y + 1)];
        LMBlock *block2 = [self blockForLocation:CGPointMake(block.gridLocation.x - 1, block.gridLocation.y - 1)];
        LMBlock *block3 = [self blockForLocation:CGPointMake(block.gridLocation.x + 1, block.gridLocation.y - 1)];
        LMBlock *block4 = [self blockForLocation:CGPointMake(block.gridLocation.x - 1, block.gridLocation.y + 1)];
        LMBlock *block5 = [self blockForLocation:CGPointMake(block.gridLocation.x + 1, block.gridLocation.y)];
        LMBlock *block6 = [self blockForLocation:CGPointMake(block.gridLocation.x - 1, block.gridLocation.y)];
        LMBlock *block7 = [self blockForLocation:CGPointMake(block.gridLocation.x, block.gridLocation.y + 1)];
        LMBlock *block8 = [self blockForLocation:CGPointMake(block.gridLocation.x, block.gridLocation.y - 1)];
        LMBlock *block9 = [self blockForLocation:CGPointMake(block.gridLocation.x, block.gridLocation.y)];
        
        if(block1 != nil && [block1 currentOccupant] == OccupantMine)mineCount++;
        if(block2 != nil && [block2 currentOccupant] == OccupantMine)mineCount++;
        if(block3 != nil && [block3 currentOccupant] == OccupantMine)mineCount++;
        if(block4 != nil && [block4 currentOccupant] == OccupantMine)mineCount++;
        if(block5 != nil && [block5 currentOccupant] == OccupantMine)mineCount++;
        if(block6 != nil && [block6 currentOccupant] == OccupantMine)mineCount++;
        if(block7 != nil && [block7 currentOccupant] == OccupantMine)mineCount++;
        if(block8 != nil && [block8 currentOccupant] == OccupantMine)mineCount++;
        if(block9 != nil && [block9 currentOccupant] == OccupantMine)mineCount++;
        
        [block setAdjacentMineCount:mineCount];
    }
}

#pragma mark -
#pragma mark Rnadom Location Utility Methods

-(CGPoint)getRandomGridLocation
{
    int x, y; 
    bool validLocation = NO;
    
    while(!validLocation)
    {
        x = (arc4random() % kGridWidth) + 1;
        y = (arc4random() % kGridHeight) + 2;
        
        for(LMBlock *block in blocks)
        {
            if(block.gridLocation.x == x && block.gridLocation.y == y && block.currentOccupant == OccupantNone)
            {
                validLocation = YES;
                
                if((mineSweeper.gridLocation.x + 1 == x && mineSweeper.gridLocation.y + 1 == y) ||
                   (mineSweeper.gridLocation.x - 1 == x && mineSweeper.gridLocation.y - 1 == y) ||
                   (mineSweeper.gridLocation.x + 1 == x && mineSweeper.gridLocation.y - 1 == y) ||
                   (mineSweeper.gridLocation.x - 1 == x && mineSweeper.gridLocation.y + 1 == y) ||
                   (mineSweeper.gridLocation.x + 1 == x && mineSweeper.gridLocation.y == y) ||
                   (mineSweeper.gridLocation.x - 1 == x && mineSweeper.gridLocation.y == y) ||
                   (mineSweeper.gridLocation.x == x && mineSweeper.gridLocation.y - 1 == y) ||
                   (mineSweeper.gridLocation.x == x && mineSweeper.gridLocation.y + 1 == y)) validLocation = NO;
                
                if(validLocation) break;
            }
            
            else if((mineSweeper.gridLocation.x + 1 == x && mineSweeper.gridLocation.y + 1 == y) ||
                    (mineSweeper.gridLocation.x - 1 == x && mineSweeper.gridLocation.y - 1 == y) ||
                    (mineSweeper.gridLocation.x + 1 == x && mineSweeper.gridLocation.y - 1 == y) ||
                    (mineSweeper.gridLocation.x - 1 == x && mineSweeper.gridLocation.y + 1 == y) ||
                    (mineSweeper.gridLocation.x + 1 == x && mineSweeper.gridLocation.y == y) ||
                    (mineSweeper.gridLocation.x - 1 == x && mineSweeper.gridLocation.y == y) ||
                    (mineSweeper.gridLocation.x == x && mineSweeper.gridLocation.y - 1 == y) ||
                    (mineSweeper.gridLocation.x == x && mineSweeper.gridLocation.y + 1 == y)) validLocation = NO;
            
           else validLocation = NO;
        }
    }
    
    return CGPointMake(x, y);
}

#pragma mark -
#pragma mark Grid Location Utility Methods

-(LMBlock *)blockForLocation:(CGPoint)location
{
    for(LMBlock *block in blocks)
    {
        if(block.gridLocation.x == location.x && block.gridLocation.y == location.y)return block;
    }
    
    return nil;
}

-(CGPoint)positionForLocation:(CGPoint)location
{
    int locationX = location.x;
    int locationY = location.y;
    float positionX = 0.0f;
    float positionY = 0.0f;
    
    positionX = kMargin + (locationX * (kBlockSize));
    positionY = (locationY * (kBlockSize)) + kFooter;
    
    return CGPointMake(positionX, positionY);
}

#pragma mark -
#pragma mark Army Methods

-(void)autoMoveArmy
{
    LMSoldier *soldier = [soldiers lastObject];
    if(soldier.gridLocation.y >= 1)return;
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"IncomingTroops.mp3"];
    for(LMSoldier *soldier in soldiers)[soldier moveAtSpeed:1.6f];
}

-(void)callArmy
{
    [[SimpleAudioEngine sharedEngine]playEffect:@"clearedToMoveForward.mp3"];
    for(LMSoldier *soldier in soldiers)[soldier moveAtSpeed:.8f];
}

#pragma mark -
#pragma mark Bombing Methods

-(void)sendBomber
{
    [[SimpleAudioEngine sharedEngine]playEffect:@"flyover.wav"];
    
    CCSprite *plane = [CCSprite spriteWithFile:@"plane.png"];
    [self addChild:plane z:21 tag:kPlaneTag];
    plane.position = ccp(160,-160);
    [plane runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3.0f],[CCMoveTo actionWithDuration:7.0f position:ccp(160,640)],nil]];
    
    id delay = [CCDelayTime actionWithDuration:10.0f];
    id func = [CCCallFuncO actionWithTarget:self selector:@selector(_initiateBombing) object:nil];
    id bomberAction = [CCSequence actions:delay, func, nil];
    [allBomberActions addObject:bomberAction];
    [self runAction:bomberAction];
}

-(void)_initiateBombing
{
    for(int i = 0; i < 10; i++)
    {
        float random = drand48();
        random += (float)(arc4random() % 2);
        
        id delay = [CCDelayTime actionWithDuration:random];
        id func = [CCCallFuncO actionWithTarget:self selector:@selector(_bombDrop) object:nil];
        id bombAction = [CCSequence actions:delay, func, nil];
        [allBomberActions addObject:bombAction];
        [self runAction:bombAction];
    }
}

-(void)_bombDrop
{
    CGPoint randPoint = [self getRandomGridLocation];
    CGPoint randPos = [self positionForLocation:randPoint];
    
    CCSprite *bomb = [CCSprite spriteWithFile:@"bomb.png"];
    bomb.position = ccp(randPos.x, randPos.y-71);
    bomb.scale = 1.5f;
    bomb.opacity = 0.0f;
    [self addChild:bomb z:19];
    
    id dropAnim = [CCMoveTo actionWithDuration:1.0f position:randPos];
    id scale = [CCScaleTo actionWithDuration:1.0f scale:.8f];
    id fadeIn = [CCFadeTo actionWithDuration:.3f opacity:255.0f];
    
    [bomb runAction:dropAnim];
    [bomb runAction:scale];
    [bomb runAction:fadeIn];
    
    id delay = [CCDelayTime actionWithDuration:1.0f];
    id func = [CCCallFuncO actionWithTarget:self selector:@selector(_bombExplosion:) object:[NSValue valueWithCGPoint:randPoint]];
    id exp = [CCSequence actions:delay, func, nil];
    [self runAction:exp];
    [allBomberActions addObject:exp];
    [allBomberActions addObject:bomb];
    
    id delay1 = [CCDelayTime actionWithDuration:1.1f];
    id func1 = [CCCallFuncO actionWithTarget:self selector:@selector(_clearBomb:) object:bomb];
    [self runAction:[CCSequence actions:delay1, func1, nil]];
    
    
}

-(void)_bombExplosion:(NSValue *)location
{
    CGPoint randPoint = [location CGPointValue];
    CGPoint randPos = [self positionForLocation:randPoint];
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"Explosion.wav"];
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
    ParticleExplosion *exp = [ParticleExplosion node];
    exp.position = CGPointMake(randPos.x,randPos.y-5);//CGPointMake(kBlockSize/2, kBlockSize/2);
    [self.parent addChild:exp z:9];
    
    SmokeSystem *smk = [SmokeSystem node];
    smk.position = CGPointMake(randPos.x,randPos.y-5);//CGPointMake(kBlockSize/2, kBlockSize/2);
    [self.parent addChild:smk z:10];
    
    if(CGPointEqualToPoint(mineSweeper.gridLocation,randPoint))[mineSweeper loseHealth];
}

-(void)_clearBomb:(CCSprite *)bomb
{
    if(bomb)[self removeChild:bomb cleanup:YES];
    
    if([self getChildByTag:kPlaneTag])[self removeChildByTag:kPlaneTag cleanup:YES];
}

-(void)cancelBombing
{
    if([self getChildByTag:kPlaneTag])[self removeChildByTag:kPlaneTag cleanup:YES];
    for(id action in allBomberActions)
    {
        if([action isKindOfClass:[CCAction class]])[self stopAction:action];
        else if([action isKindOfClass:[CCSprite class]])[self removeChild:action cleanup:YES];
    }
}

#pragma mark -
#pragma mark Get Methods

-(CCArray *)getSoldiers
{
    return soldiers;
}

-(CCArray *)getBlocks
{
    return blocks;
}

#pragma mark -
#pragma mark Game State

-(void)pause
{
    isPaused = !isPaused;
    [mineSweeper pause];
    for(LMSoldier *soldier in soldiers)[soldier pause];
}

#pragma mark - 
#pragma mark Cheat Methods

-(void)callSheep
{
    int x = 1;
    int y = -2;
    
    for(int i = 0; i < kGridWidth; i++)
    {
        LMSheep *newSheep = [[LMSheep alloc]initWithOwningGrid:self];
        newSheep.gridLocation = CGPointMake(x, y);
        newSheep.position = [self positionForLocation:newSheep.gridLocation];
        newSheep.position = CGPointMake(newSheep.position.x, newSheep.position.y + (kBlockSize/2));
        [self addChild:newSheep z:kSoldierZ];
        [newSheep moveAtSpeed:1.5f];
        x++;
    }
}

#pragma mark -
#pragma mark Cleanup

-(void)dealloc
{
    [allBomberActions release];
    [blocks release];
    [soldiers release];
    [mineSweeper release];
    [super dealloc];
}

@end
