//
//  LMSceneryProducer.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/3/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMSceneryProducer.h"
#import "LMGridManager.h"
#import "FogSystem.h"

@implementation LMSceneryProducer

-(void)placeSceneryAndFogAllowed:(BOOL)fogAllowed
{    
    int tag = kSceneryTagStartNum;
    
    for(int i = 0; i < 117; i++)
    {
        occupiedLocations[i] = CGPointZero;
    }
    
    for(int i = 0; i < 4; i++)
    {        
        CCSprite *sceneryItem = [CCSprite spriteWithFile:@"hedgehog1.png"];
        sceneryItem.scale = 1.3f;
        
        CGPoint gridLocation = [self getRandomGridLocation];
        sceneryItem.position = [self positionForLocation:gridLocation];
        occupiedLocations[i] = sceneryItem.position;
                 
        [self.parent addChild:sceneryItem z:kGridHeight - (gridLocation.y - 1) tag:tag];
        tag++;
    }
    
    for(int i = 0; i < 20; i++)
    {        
        CCSprite *sceneryItem;
        
        int randomInt = (arc4random() % 4) + 1;
        
        if(randomInt == 1) sceneryItem = [CCSprite spriteWithFile:@"Grass1.png"];
        else if (randomInt == 2)sceneryItem = [CCSprite spriteWithFile:@"Grass2.png"];
        else if (randomInt == 3)sceneryItem = [CCSprite spriteWithFile:@"Grass3.png"];
        else sceneryItem = [CCSprite spriteWithFile:@"Grass4.png"];
        
        if(randomInt == 1) sceneryItem.scale = .7f;
        
        CGPoint gridLocation = [self getRandomGridLocation];
        sceneryItem.position = [self positionForLocation:gridLocation];
        occupiedLocations[i+4] = sceneryItem.position;
                
        [self.parent addChild:sceneryItem z:kGridHeight - (gridLocation.y - 1) tag:tag];
        tag++;
    }
    
    
    for(int i = 0; i < 4; i++)
    {        
        CCSprite *sceneryItem = [CCSprite spriteWithFile:@"sandBag.png"];
        
        CGPoint gridLocation = [self getRandomGridLocation];
        sceneryItem.position = [self positionForLocation:gridLocation];
        occupiedLocations[i+24] = sceneryItem.position;
                
        [self.parent addChild:sceneryItem z:kGridHeight - (gridLocation.y - 1) tag:tag];
        tag++;
    }
    
    int randFogNum = (arc4random() % 5) + 1;
        
    if(randFogNum == 5 && fogAllowed)
    {
        tag++;
        FogSystem *fog = [FogSystem node];
        fog.position = ccp(160,560);
        [self.parent addChild:fog z:20 tag:tag];
    }
}

-(CGPoint)getRandomGridLocation
{
    int x, y; 
    bool validLocation;
    
    do
    {
        validLocation = YES;
        
        x = (arc4random() % kGridWidth) + 1;
        y = (arc4random() % kGridHeight) + 1;
        
        for(int i = 0; i < 117; i++)
        {
            if(CGPointEqualToPoint(occupiedLocations[i], [self positionForLocation:CGPointMake(x, y)])) validLocation = NO;
        }
        
    } while(!validLocation);
    
    return CGPointMake(x, y);
}

-(CGPoint)positionForLocation:(CGPoint)location
{
    int locationX = location.x;
    int locationY = location.y;
    float positionX = 0.0f;
    float positionY = 0.0f;
    
    positionX = kMargin + (locationX * (kBlockSize));
    positionY = (locationY * (kBlockSize)) + kFooter;
    
    return CGPointMake(positionX, positionY);//Reveresed only due to Cocos2d reveserve x/y plain.
}

@end
