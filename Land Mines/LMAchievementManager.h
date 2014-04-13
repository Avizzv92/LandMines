//
//  LMAchievementManager.h
//  Land Mines
//
//  Created by Aaron Vizzini on 2/21/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMGridManager;

@interface LMAchievementManager : NSObject

+(void)checkAchvForGrid:(LMGridManager *)gridManager;

@end
