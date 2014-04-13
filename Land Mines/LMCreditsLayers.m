//
//  LMCreditsLayers.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/15/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "cocos2d.h"

#import "LMCreditsLayers.h"
#import "LMGameScene.h"
#import "SimpleAudioEngine.h"

@implementation LMCreditsLayers

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.isTouchEnabled = YES;
        
        CCSprite *credits = [CCSprite spriteWithFile:@"credits.png"];
        credits.scale = .6f;
        credits.position = ccp(-150, -150);
        [self addChild:credits z:0 tag:0];
        credits.rotation = -140.0f;
        id rocking = [CCRepeat actionWithAction:[CCSequence actions:[CCEaseIn actionWithAction:[CCRotateBy actionWithDuration:1.2f angle:160] rate:2.0f], nil] times:1];
    
        
        ccBezierConfig bezier;
        bezier.controlPoint_1 = ccp(0, 100);
        bezier.controlPoint_2 = ccp(300, 200);
        bezier.endPosition = ccp(300,370);
        
        id bezierForward = [CCBezierBy actionWithDuration:1.2f bezier:bezier];
        
        [credits runAction:rocking];
        [credits runAction:bezierForward];
        [credits runAction:[CCScaleTo actionWithDuration:1.2f scale:.6f]];
    }
    
    return self;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
        
    if(point.x > 206 && point.y > 385 && point.y < 447)
    {
        [[SimpleAudioEngine sharedEngine]playEffect:@"press.mp3"];
        [[CCDirector sharedDirector]resume];
        [[CCDirector sharedDirector]replaceScene:[CCTransitionMoveInR transitionWithDuration:0.3f scene:[LMGameScene node]]];
    }
}

@end
