//
//  LMGameMenus.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/7/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMGameMenus.h"
#import "LMGameManager.h"
#import "SimpleAudioEngine.h"
#import "FileHelper.h"
#import "LMGameCenterManager.h"
#import "GlobalManager.h"
#import "LMCreditsScene.h"
#import "LMTutorialScene.h"

#define kPauseTag 1
#define kOverTag 2

@implementation LMGameMenus
@synthesize gm;

#pragma mark -
#pragma mark init

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {     
        bird = [CCSprite spriteWithFile:@"bird.png"];
        bird.position = ccp(450, 240);
        [self addChild:bird];
        
        birdNum = [CCLabelTTF labelWithString:@"1" fontName:@"Braggadocio" fontSize:15];
        birdNum.position = ccp(102, 14);
        birdNum.anchorPoint = ccp(0.0f,.5f);
        [birdNum setColor:ccBLACK];
        [bird addChild:birdNum];
        
        NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
        
        sfxSlider = [[UISlider alloc]initWithFrame:CGRectMake(158, 149, 100, 25)];
        [sfxSlider setValue:[[settingsDictionary objectForKey:@"SFXVolume"]floatValue]];
        [sfxSlider addTarget:self action:@selector(volumeSFXChange) forControlEvents:UIControlEventValueChanged];	
        [sfxSlider setMaximumValue:1.0f];
        [sfxSlider setMinimumValue:0.0f];
        
        musicSlider = [[UISlider alloc]initWithFrame:CGRectMake(158, 178, 100, 25)];
        [musicSlider setValue:[[settingsDictionary objectForKey:@"MusicVolume"]floatValue]];
        [musicSlider addTarget:self action:@selector(volumeMusicChange) forControlEvents:UIControlEventValueChanged];	
        [musicSlider setMaximumValue:1.0f];
        [musicSlider setMinimumValue:0.0f];
        
        [settingsDictionary release];
        
        gcm = [[LMGameCenterManager alloc]init];
    }
    
    return self;
}

#pragma mark -
#pragma mark UI Methods

-(void)showPhaseNumber:(int)phase
{
    [birdNum setString:[NSString stringWithFormat:@"%i",phase]];
    
    id move = [CCMoveTo actionWithDuration:5.0f position:CGPointMake(-90, 240)];
    
    [bird runAction:[CCSequence actions:move,[CCMoveTo actionWithDuration: 0.0f position:CGPointMake(400,240)], nil]];
}

-(void)showPauseMenu
{
    self.isTouchEnabled = YES;

    CCSprite *menu = [CCSprite spriteWithFile:@"menuPause.png"];
    menu.position = ccp(-160, 960);
    [self addChild:menu z:0 tag:kPauseTag];
    
    CCLabelTTF *objective = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(100, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Braggadocio" fontSize:15];
    [menu addChild:objective z:1];
    objective.position = ccp(120,115);
    [objective setColor:ccBLACK];
    
    id moveAction = [CCMoveTo actionWithDuration:0.7f position:ccp(160, 240)];
    moveAction = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    [menu runAction:moveAction];
    
    [[CCDirector sharedDirector] performSelector:@selector(pause) withObject:nil afterDelay:1.0f];
    
    [self performSelector:@selector(_showPauseUI) withObject:nil afterDelay:1.0f];
    
    [[GlobalManager sharedManager]setIsGamePaused:YES];
    
    NSDictionary *settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"acvhDesc" ofType:@"plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *achvs = [dict objectForKey:@"Root"];
    [objective setString:[achvs objectAtIndex:[[settingsDictionary objectForKey:@"CurrentObjective"]intValue]]];
    [settingsDictionary release];
}

-(void)_showPauseUI
{
    [[[CCDirector sharedDirector]openGLView]addSubview:sfxSlider];
    [[[CCDirector sharedDirector]openGLView]addSubview:musicSlider];
}

-(void)hidePauseMenu
{
    self.isTouchEnabled = NO;
    [[GlobalManager sharedManager]setIsGamePaused:NO];

    id moveAction = [CCMoveTo actionWithDuration:.7f position:ccp(-160, 960)];
    moveAction = [CCEaseIn actionWithAction:moveAction rate:1.5f];
    [[self getChildByTag:kPauseTag] runAction:moveAction];
    [[CCDirector sharedDirector]resume];
    [self.gm pause];
    
    NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
    [settingsDictionary setObject:[NSNumber numberWithFloat:musicSlider.value] forKey:@"MusicVolume"];
    [settingsDictionary setObject:[NSNumber numberWithFloat:musicSlider.value] forKey:@"SFXVolume"];
    [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
    [settingsDictionary release];
    
    [sfxSlider removeFromSuperview];
    [musicSlider removeFromSuperview];
    
    [self performSelector:@selector(_cleanUpPauseMenu) withObject:self afterDelay:1.0f];
}

-(void)_cleanUpPauseMenu
{
    [self removeChildByTag:kPauseTag cleanup:YES];
}

-(void)showGameOver
{
    self.isTouchEnabled = YES;
    
    CCSprite *menu = [CCSprite spriteWithFile:@"menuFailed.png"];
    menu.position = ccp(-160, 960);
    [self addChild:menu z:0 tag:kOverTag];
    
    CCLabelTTF *objective = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(100, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Braggadocio" fontSize:15];
    [menu addChild:objective z:1];
    objective.position = ccp(120,115);
    [objective setColor:ccBLACK];
    
    CCLabelTTF *phaseNum = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",[self.gm getCurrentPhase]] dimensions:CGSizeZero alignment:UITextAlignmentCenter  fontName:@"Braggadocio" fontSize:40];
    phaseNum.position = ccp(160, 247);
    [phaseNum setColor:ccBLACK];
    [menu addChild:phaseNum];
    
    id moveAction = [CCMoveTo actionWithDuration:.9f position:ccp(160, 240)];
    
    moveAction = [CCEaseIn actionWithAction:moveAction rate:2.0f];
    
    [menu runAction:moveAction];
    
    [[CCDirector sharedDirector] performSelector:@selector(pause) withObject:nil afterDelay:1.1f];
    
    NSString *strFullURL = [NSString stringWithFormat:@"http://alternativevisuals.com/av/totallandmines.php?mines=%i",self.gm.totalMines];
    NSURL *url = [[NSURL alloc]initWithString:strFullURL];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
    [url release];
    [req release];
    
    NSDictionary *settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"acvhDesc" ofType:@"plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSArray *achvs = [dict objectForKey:@"Root"];
    [objective setString:[achvs objectAtIndex:[[settingsDictionary objectForKey:@"CurrentObjective"]intValue]]];
    [settingsDictionary release];
}

-(void)hideGameOver
{
    self.isTouchEnabled = NO;
    
    id moveAction = [CCEaseSineIn actionWithAction:[CCMoveTo actionWithDuration:1.0f position:ccp(-160, 960)]];
    moveAction = [CCEaseIn actionWithAction:moveAction rate:2.0f];
    [[self getChildByTag:kOverTag] runAction:moveAction];
    [[CCDirector sharedDirector]resume];
    [self performSelector:@selector(_cleanUpGameMenu) withObject:self afterDelay:1.0f];
}

-(void)_cleanUpGameMenu
{
    [self removeChildByTag:kOverTag cleanup:YES];
}

-(void)showCredits
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Caution" message:@"You will lose all progress in the current game, continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert setTag:0];
    [alert release];
}

-(void)showTutorial
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Caution" message:@"You will lose all progress in the current game, continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert setTag:1];
    [alert release];
}

#pragma mark -
#pragma mark UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[FileHelper getSettingsPath]];
        [settingsDictionary setObject:[NSNumber numberWithFloat:musicSlider.value] forKey:@"MusicVolume"];
        [settingsDictionary setObject:[NSNumber numberWithFloat:musicSlider.value] forKey:@"SFXVolume"];
        [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
        [settingsDictionary release];
        
        [sfxSlider removeFromSuperview];
        [musicSlider removeFromSuperview];
        
        [[CCDirector sharedDirector]resume];
        if([alertView tag]==0)[[CCDirector sharedDirector]replaceScene:[CCTransitionMoveInL transitionWithDuration:0.3f scene:[LMCreditsScene node]]];
        else [[CCDirector sharedDirector]replaceScene:[CCTransitionMoveInL transitionWithDuration:0.3f scene:[LMTutorialScene node]]];
    }
}

#pragma mark -
#pragma mark Audio Methods

-(void)volumeMusicChange
{
	[[SimpleAudioEngine sharedEngine]setEffectsVolume:sfxSlider.value];
	[[SimpleAudioEngine sharedEngine]setBackgroundMusicVolume:musicSlider.value];
}

-(void)volumeSFXChange
{
	[[SimpleAudioEngine sharedEngine]setEffectsVolume:sfxSlider.value];
	[[SimpleAudioEngine sharedEngine]setBackgroundMusicVolume:musicSlider.value];
}

#pragma mark -
#pragma mark Touch Methods

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self getChildByTag:kPauseTag] != nil)
    {
        [sfxSlider removeFromSuperview];
        [musicSlider removeFromSuperview];
    
        [[[CCDirector sharedDirector]openGLView]addSubview:sfxSlider];
        [[[CCDirector sharedDirector]openGLView]addSubview:musicSlider];
    }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];

    if(point.x > 221 && point.y > 405 && [self getChildByTag:kPauseTag] != nil)
    {
        [[SimpleAudioEngine sharedEngine]playEffect:@"press.mp3"];
        [self hidePauseMenu];
    }
    
    if(point.x > 221 && point.y > 405 && [self getChildByTag:kOverTag] != nil)
    {
        [[SimpleAudioEngine sharedEngine]playEffect:@"press.mp3"];
        [self.gm loadGame];
        [self hideGameOver];
    }
    
    if(point.x > 220 && point.x < 260 && point.y > 307 && point.y < 373)
    {    
        [[SimpleAudioEngine sharedEngine]playEffect:@"press.mp3"];
        [gcm reorderView];
        [gcm showAchievments];
    }
    
    if(point.x > 50 && point.x < 153 && point.y > 215 && point.y < 282 && [self getChildByTag:kPauseTag] != nil)
    {
        [[SimpleAudioEngine sharedEngine]playEffect:@"press.mp3"];
        [self showCredits];
    }
    
    if(point.x > 187 && point.x < 276 && point.y > 215 && point.y < 282 && [self getChildByTag:kPauseTag] != nil)
    {
        [[SimpleAudioEngine sharedEngine]playEffect:@"press.mp3"];
        [self showTutorial];
    }
}

-(void)dealloc
{
    [sfxSlider release];
    [musicSlider release];
    [gcm release];
    [super dealloc];
}

@end
