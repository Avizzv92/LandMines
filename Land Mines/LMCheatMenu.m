//
//  CTCheatMenu.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 2/4/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMCheatMenu.h"
#import "cocos2d.h"
#import "GlobalManager.h"
#import "LMGridManager.h"
#import "SimpleAudioEngine.h"

#define kFontSize 25

@implementation LMCheatMenu
@synthesize grid;

#pragma mark -
#pragma mark Init Method

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        self.isTouchEnabled = YES;
        
        cheatBox = [[UITextField alloc]initWithFrame:CGRectMake(35, 200, 250, 25)];
		[cheatBox setDelegate:self];
        [cheatBox setPlaceholder:@"Ally Support..."];
		cheatBox.textColor = [UIColor blackColor];
        [cheatBox setBackgroundColor:[UIColor whiteColor]];
		cheatBox.font = [UIFont fontWithName:@"WetPaint" size:kFontSize];
    }
    
    return self;
}

#pragma mark -
#pragma mark Touch Method

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [cheatBox removeFromSuperview];
    [cheatBox resignFirstResponder];
}

#pragma mark -
#pragma mark Display Method

-(void)show
{
    [[[CCDirector sharedDirector]openGLView]addSubview:cheatBox];
}

#pragma mark -
#pragma mark Cheat Method

-(void)_didEnterCheat:(LMCheat)cheatType
{
    if(cheatType == LMScotland)
    {
        [self.grid callSheep];
        [[GlobalManager sharedManager]setFlagType:@"flagScotland.png"];
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"STB.mp3" loop:YES];
    }
    
    if(cheatType == LMFrance)
    {
        [[GlobalManager sharedManager]setFlagType:@"flagFrance.png"];
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"marseillaise.mp3" loop:YES];
    }
    
    if(cheatType == LMClear)
    {
        [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
        [[GlobalManager sharedManager]setFlagType:@"flag.png"];
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"military.mp3" loop:YES];
    }
}

#pragma mark -
#pragma mark Textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	[textField resignFirstResponder];
    [textField setText:[textField.text capitalizedString]];
    
    if([textField.text isEqualToString: @"Scotland The Brave"])[self _didEnterCheat:LMScotland];
    else if ([textField.text isEqualToString: @"Belle France"])[self _didEnterCheat:LMFrance];
    else if([textField.text isEqualToString: @"Stop"])[self _didEnterCheat:LMClear];
    
    [textField setText:@""];
    
    [cheatBox removeFromSuperview];
    
	return YES;
}

#pragma mark -
#pragma mark Clean up

-(void)dealloc
{
    [cheatBox removeFromSuperview];
    [cheatBox release];
    [super dealloc];
}

@end
