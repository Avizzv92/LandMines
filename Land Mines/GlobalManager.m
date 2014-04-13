//
//  GlobalManager.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/4/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "GlobalManager.h"

static GlobalManager *sharedInstance = nil;

@implementation GlobalManager
@synthesize isGamePaused;

#pragma mark -
#pragma mark class instance methods

-(void)setFlagType:(NSString *)flag
{
    flagType = flag;
}

-(NSString *)getFlagType
{
    return flagType;
}

#pragma mark -
#pragma mark Singleton methods

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        flagType = @"flag.png";
        isGamePaused = NO;
    }
    
    return self;
}

+ (GlobalManager*)sharedManager
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[GlobalManager alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)retain{
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

-(void)release {
    //do nothing
}

-(id)autorelease {
    return self;
}

@end