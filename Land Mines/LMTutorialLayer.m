//
//  LMTutorialLayer.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/24/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMTutorialLayer.h"
#import "cocos2d.h"
#import "LMGameScene.h"
#import "FileHelper.h"
#import "LMGameCenterManager.h"
#import "SimpleAudioEngine.h"

@implementation LMTutorialLayer

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.isTouchEnabled = YES;

        NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
        int currentObjective = [[settingsDictionary objectForKey:@"CurrentObjective"]intValue];
        
        if(currentObjective == 0)
        {
            currentObjective++;
            LMGameCenterManager *gcm = [[LMGameCenterManager alloc]init];
            [gcm submitAchievementId:[NSString stringWithFormat:@"%i",currentObjective] fullName:@""];
            [gcm release];
        }
        
        [settingsDictionary setValue:[NSNumber numberWithInt:currentObjective] forKey:@"CurrentObjective"];
        [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
        
    }
    
    return self;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
        
    if(point.x > 230 && point.y > 433)
    {
        [[SimpleAudioEngine sharedEngine]playEffect:@"press.mp3"];
        [[CCDirector sharedDirector]resume];
        [[CCDirector sharedDirector]replaceScene:[CCTransitionMoveInR transitionWithDuration:0.3f scene:[LMGameScene node]]];
    }
}

@end
