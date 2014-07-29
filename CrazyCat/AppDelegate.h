//
//  AppDelegate.h
//  CrazyCat
//
//  Created by zhaozilong on 14-7-24.
//  Copyright __MyCompanyName__ 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
