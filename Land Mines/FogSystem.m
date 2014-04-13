//
//  FogSystem.m
//  Land Mines
//
//  Created by Aaron Vizzini on 2/9/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "FogSystem.h"

@implementation FogSystem

#pragma mark -
#pragma mark Init Method(s)

-(id) init
{
	return [self initWithTotalParticles:50];
}

-(id) initWithTotalParticles:(NSUInteger)p
{
	if( (self=[super initWithTotalParticles:p]) ) {
        
        // duration
        self.duration = kCCParticleDurationInfinity;
		
		self.emitterMode = kCCParticleModeGravity;
        
		// Gravity Mode: gravity
		self.gravity = ccp(2, -10);
		
		// Gravity Mode: radial
		self.radialAccel = 0;
		self.radialAccelVar = 1;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 1;
        
		// Gravity Mode: speed of particles
		self.speed = 130;
		self.speedVar = 30;
		
		// angle
		angle = -90;
		angleVar = 5;        
        
        // emitter position
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.position = ccp(winSize.width/2, winSize.height/2);
        posVar = ccp(320, 5);
        
        // life of particles
        life = 15;
        lifeVar = 0;
        
        // speed of particles
        self.speed = 20;
        self.speedVar = 8;
        
        // size, in pixels
        startSize = 275.0f;
        startSizeVar = 5.0f;
        endSize = 275.0f;
        
        // emits per frame
        emissionRate = 2;
        
        // color of particles
        startColor.r = 0.3f;
        startColor.g = 0.3f;
        startColor.b = 0.3f;
        startColor.a = .5f;
        startColorVar.r = 0.01f;
        startColorVar.g = 0.01f;
        startColorVar.b = 0.01f;
        startColorVar.a = 0.0f;
        endColor.r = 0.3f;
        endColor.g = 0.3f;
        endColor.b = 0.3f;
        endColor.a = 0.5f;
        endColorVar.r = 0.01f;
        endColorVar.g = 0.01f;
        endColorVar.b = 0.01f;
        endColorVar.a = 0.4f;
        
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
        self.texture = [[CCTextureCache sharedTextureCache] addImage: @"engineSmoke.png"];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        // additive
        self.blendAdditive = NO;
        
    }
	
	return self;
}
@end

