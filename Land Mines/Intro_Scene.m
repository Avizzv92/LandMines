//
//  Intro_Scene.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 10/16/09.
//  Modified by Aaron Vizzini on 6/1/11.
//  Copyright 2009 Alternative Visuals. All rights reserved.
//
//  Website:
//  http://www.alternativevisuals.com
//

#import "Intro_Scene.h"

#import "LMGameScene.h"
#import "LMTutorialScene.h"
#import "SimpleAudioEngine.h"
#import "FileHelper.h"

@implementation Intro_Scene

#pragma mark -
#pragma mark Init Method

-(id) init
{
	self = [super init];
	
	if(self != nil)
	{
		[[SimpleAudioEngine sharedEngine] playEffect:@"Intro.wav"];
		
		logo = [CCSprite spriteWithFile:@"AVlogo_1.png"];
		logo.position = ccp(-75, -10);
		logo.scale = 1.0f;
		[self addChild: logo];
		
		id action0 = [CCMoveTo actionWithDuration:0 position:ccp(160,270)];
		id action1 = [CCFadeIn actionWithDuration:3];
		id action2 = [CCFadeOut actionWithDuration:3];
		id action3 = [CCCallFunc actionWithTarget:self selector:@selector(changeScene)];
		
		[logo runAction: [CCSequence actions:action0,action1, action2, action3, nil]];
		
		label = [CCLabelTTF labelWithString:@"Alternative Visuals" fontName:@"Verdana" fontSize:22];
		label.position = ccp(160, 120);
		[self addChild:label];
		
	}
	
	return self;
}

-(void)changeScene
{
    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
    bool isNew = [[settingsDictionary objectForKey:@"isNew"]intValue];
    [settingsDictionary release];
    
    if(isNew)
    {
        NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
        [settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"isNew"];
        [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
        [settingsDictionary release];
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.4 scene: [LMTutorialScene node]]];
    }
    
	else [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.4 scene: [LMGameScene node]]];
}

@end
