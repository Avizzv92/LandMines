//
//  LMGameScene.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/30/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMGameScene.h"
#import "SimpleAudioEngine.h"
#import "LMGameManager.h"

@implementation LMGameScene

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        [self addChild:[LMGameManager node]];
    }
    
    return self;
}

-(void)onExit
{
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    [super onExit];
}
@end
