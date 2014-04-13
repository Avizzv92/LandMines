//
//  LMSceneryProducer.h
//  Land Mines
//
//  Created by Aaron Vizzini on 2/3/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "cocos2d.h"

@interface LMSceneryProducer : CCLayer
{
    CGPoint occupiedLocations[117];
}

-(void)placeSceneryAndFogAllowed:(BOOL)fogAllowed;

-(CGPoint)getRandomGridLocation;

-(CGPoint)positionForLocation:(CGPoint)location;
@end
