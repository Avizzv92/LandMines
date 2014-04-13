//
//  CTCheatMenu.h
//  Cat Trap 2
//
//  Created by Aaron Vizzini on 2/4/12.
//  Copyright (c) 2012 Alternative Visuals. All rights reserved.
//

#import "CCLayer.h"

@class LMGridManager;

typedef enum {LMScotland, LMFrance, LMClear}LMCheat;

@interface LMCheatMenu : CCLayer <UITextFieldDelegate>
{
    UITextField *cheatBox;
    LMGridManager *grid;
}

@property(assign)LMGridManager *grid;

-(void)show;
-(void)_didEnterCheat:(LMCheat)cheatType;

@end
