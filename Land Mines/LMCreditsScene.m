//
//  LMCreditsScene.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/15/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMCreditsScene.h"
#import "LMCreditsLayers.h"
#import "cocos2d.h"

@implementation LMCreditsScene

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"wood.png"];
        bg.position = ccp(160,240);
        [self addChild:bg];
        
        [self addChild:[LMCreditsLayers node]];
    }
    
    return self;
}

@end
