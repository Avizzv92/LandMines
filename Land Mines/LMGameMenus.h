//
//  LMGameMenus.h
//  Land Mines
//
//  Created by Aaron Vizzini on 2/7/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "cocos2d.h"

@class LMGameManager;
@class LMGameCenterManager;

@interface LMGameMenus : CCLayer <UIAlertViewDelegate>
{
    CCSprite *bird;
    CCLabelTTF *birdNum;
    
    CCSprite *pauseMenu;
    CCSprite *gameOverMenu;
    
    LMGameManager *gm;
    
    UISlider *musicSlider;
    UISlider *sfxSlider;
        
    LMGameCenterManager *gcm;
}
@property (nonatomic, assign)LMGameManager *gm;

-(void)showPhaseNumber:(int)phase;
-(void)showPauseMenu;
-(void)hidePauseMenu;
-(void)showGameOver;
-(void)hideGameOver;
-(void)showCredits;
-(void)showTutorial;

@end
