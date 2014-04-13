//
//  LMGridManager.h
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "CCLayer.h"
#import "LMSceneryProducer.h"

#define kGridWidth 9
#define kGridHeight 13
#define kBlockSize 35.5
#define kFooter -(kBlockSize/2)
#define kMargin -(kBlockSize/2)
#define kSceneryTagStartNum 8476

@class LMBlock;
@class LMMineSweeper;
@class LMSoldier;
@class LMGameManager;

@interface LMGridManager : CCLayer
{
    BOOL isPaused;
    
    LMGameManager *gameManager;
    
    CCSprite *bg;
    
    CCArray *blocks;
    CCArray *soldiers;
    LMMineSweeper *mineSweeper;
    
    LMSceneryProducer *sp;
    
    NSMutableArray *allBomberActions;
}
@property(nonatomic, assign)LMGameManager *gameManager;
@property(nonatomic, retain)LMMineSweeper *mineSweeper;

-(void)loadGridWithMineCount:(int)mineCount healthPackCount:(int)healthCount;
-(void)advanceGridWithMineCount:(int)mineCount healthPackCount:(int)healthCount;

-(void)placeArmy;
-(void)placeMines:(int)mineCount;
-(void)placeHealthPakcs:(int)healthPackCount;
-(void)setAdjacentMineCounts;
-(CGPoint)getRandomGridLocation;

-(CGPoint)positionForLocation:(CGPoint)location;
-(LMBlock *)blockForLocation:(CGPoint)location;

-(void)autoMoveArmy;
-(void)callArmy;

-(CCArray *)getSoldiers;
-(CCArray *)getBlocks;

-(void)sendBomber;
-(void)cancelBombing;

-(void)pause;

-(void)callSheep;

@end
