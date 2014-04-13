//
//  GlobalManager.h
//  Land Mines
//
//  Created by Aaron Vizzini on 2/4/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalManager : NSObject
{
    NSString *flagType;
    BOOL isGamePaused;
}
@property(readwrite) BOOL isGamePaused;

+ (GlobalManager*)sharedManager;

-(void)setFlagType:(NSString *)flag;
-(NSString *)getFlagType;

@end
