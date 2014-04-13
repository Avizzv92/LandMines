//
//  FileHelper.m
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 6/13/11.
//  Copyright 2011 Alternative Visuals. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

#pragma mark -
#pragma mark File Path Helpers

+(NSString *)getSettingsPath
{
    return [[self getDefaultDirectory] stringByAppendingPathComponent:@"UserSettings"];
}

+(NSString *)getDefaultDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

@end
