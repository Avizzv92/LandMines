//
//  LMAchievementManager.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/21/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "LMAchievementManager.h"
#import "LMGridManager.h"
#import "LMGameManager.h"
#import "LMMineSweeper.h"
#import "FileHelper.h"
#import "LMGameCenterManager.h"

@implementation LMAchievementManager

+(void)checkAchvForGrid:(LMGridManager *)gridManager
{
    NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[FileHelper getSettingsPath]];
   
    int oldObjectiveNum = [[settingsDictionary objectForKey:@"CurrentObjective"]intValue];
    int currentObjective = oldObjectiveNum;
        
    if(currentObjective == 1)
    {
        bool isThereAFlag = NO;
        
        for(LMBlock *block in [gridManager getBlocks])
            if([block isFlagged])
                isThereAFlag = YES;
        
        if(isThereAFlag)currentObjective++;//Flag a Mines.
    }
    
    else if(currentObjective == 2 && gridManager.gameManager.getCurrentPhase >= 1)
    {
       //clear first field
        currentObjective++;
    }
    
    else if(currentObjective == 3 && gridManager.gameManager.getCurrentPhase >= 1 && gridManager.gameManager.advanceCalled == NO)
    {
        currentObjective++;//Clear a field before ally troops arrive
    }
    
    else if(currentObjective == 4 && gridManager.gameManager.getCurrentPhase >= 3 && gridManager.mineSweeper.health == 3)
    {
       //Clear 3 fields with no injuries
        currentObjective++;
    }
    
    else if(currentObjective == 5 && gridManager.gameManager.getCurrentPhase >= 5)
    {
        //Clear 5 fields 
        currentObjective++;
    }
    
    else if(currentObjective == 6)
    {
        bool wasThereNonWalkedOnArea = NO;
        
        for(LMBlock *block in [gridManager getBlocks])
            if([block currentOccupant] != OccupantTrampledGround && [block currentOccupant] != OccupantExploded && ![block isFlagged])wasThereNonWalkedOnArea = YES;
        
        if(!wasThereNonWalkedOnArea)currentObjective++;//Walk on every space of any field
    }
    
    else if(currentObjective == 7 && gridManager.gameManager.getCurrentPhase >= 7 && gridManager.mineSweeper.health == 3)
    {
        //Clear 7 fields with no injuries
        currentObjective++;
    }
    
    else if(currentObjective == 8 && gridManager.gameManager.getCurrentPhase >= 10)
    {
        //Clear 10 fields
        currentObjective++;
    }
    
    
    else if(currentObjective == 9 && gridManager.gameManager.getCurrentPhase >= 15)
    {
        //Clear 15 fields
        currentObjective++;
    }
    
    else if(currentObjective == 10 && gridManager.gameManager.getCurrentPhase >= 20 && gridManager.mineSweeper.health == 3)
    {
        //Clear 20 fields with no injuries
        currentObjective++;
    }
    
    else if(currentObjective == 11 && gridManager.gameManager.getCurrentPhase >= 25 && [[gridManager getSoldiers]count] == 9)
    {
        //No soldiers lost after 25
        currentObjective++;
    }
    
    else if(currentObjective == 12 && gridManager.gameManager.getCurrentPhase >= 30)
    {
        //Clear 30 fields
        currentObjective++;
    }
    
    else if(currentObjective == 13 && gridManager.gameManager.getCurrentPhase >= 35 && gridManager.mineSweeper.health == 3)
    {
        //Clear 35 fields with no injuries
        currentObjective++;
    }
    
    else if(currentObjective == 11 && gridManager.gameManager.getCurrentPhase >= 40 && [[gridManager getSoldiers]count] == 9)
    {
        //No soldiers lost after 40
        currentObjective++;
    }
    
    if(oldObjectiveNum != currentObjective)
    {
        LMGameCenterManager *gcm = [[LMGameCenterManager alloc]init];
        
        [gcm submitAchievementId:[NSString stringWithFormat:@"%i",currentObjective-1] fullName:@""];
        
        [gcm release];
    }
    
    [settingsDictionary setValue:[NSNumber numberWithInt:currentObjective] forKey:@"CurrentObjective"];
    [settingsDictionary writeToFile:[FileHelper getSettingsPath] atomically:YES];
}

@end
