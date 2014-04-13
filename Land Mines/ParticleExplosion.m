//
//  ParticleExplosion.m
//  Land Mines
//
//  Created by Aaron Vizzini on 1/30/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "ParticleExplosion.h"

@implementation ParticleExplosion

-(id) init
{
	return [self initWithTotalParticles:500];
}

-(id) initWithTotalParticles:(NSUInteger)p
{
	if( (self=[super initWithTotalParticles:p]) ) {
        
		// duration
		duration = 0.1f;
		
		self.emitterMode = kCCParticleModeGravity;
        
		// Gravity Mode: gravity
		self.gravity = ccp(0,-180);
		
		// Gravity Mode: speed of particles
		self.speed = 80;
		self.speedVar = 50;
		
		// Gravity Mode: radial
		self.radialAccel = 1;
		self.radialAccelVar = 0;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 0;
		
		// angle
		angle = 90;
		angleVar = 80;//360;
        
		// emitter position
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		self.position = ccp(winSize.width/2, winSize.height/2);
		posVar = CGPointZero;
		
		// life of particles
		life = .9f;
		lifeVar = .3f;
		
		// size, in pixels
		startSize = 3.0f;
		startSizeVar = 1.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
        
		// emits per second
		emissionRate = totalParticles/duration;
		
		// color of particles
        startColor.r = 1.0f;
        startColor.g = 1.0f;
        startColor.b = 1.0f;
        startColor.a = 1.0f;
        startColorVar.r = 0.1f;
        startColorVar.g = 0.1f;
        startColorVar.b = 0.1f;
        startColorVar.a = 0.1f;
        endColor.r = 0.0f;
        endColor.g = 0.0f;
        endColor.b = 0.0f;
        endColor.a = 0.0f;
        endColorVar.r = 0.0f;
        endColorVar.g = 0.0f;
        endColorVar.b = 0.0f;
        endColorVar.a = 0.0f;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"explosionParticle.png"];
        
		// additive
		self.blendAdditive = NO;
	}
	
	return self;
}

@end
