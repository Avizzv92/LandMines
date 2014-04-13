//
//  LMTutorialScene.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/24/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMTutorialScene.h"
#import "cocos2d.h"
#import "LMTutorialLayer.h"

@implementation LMTutorialScene

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"tutorial.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
        
        [self addChild:[LMTutorialLayer node]];
    }
    
    return self;
}

@end
