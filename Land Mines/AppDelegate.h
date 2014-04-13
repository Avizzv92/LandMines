//
//  AppDelegate.h
//  Land Mines
//
//  Created by Aaron Vizzini on 1/27/12.
//  Copyright Alternative Visuals 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
