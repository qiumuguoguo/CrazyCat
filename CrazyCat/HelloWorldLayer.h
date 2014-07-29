//
//  HelloWorldLayer.h
//  CrazyCat
//
//  Created by zhaozilong on 14-7-24.
//  Copyright __MyCompanyName__ 2014年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "RootViewController.h"
#import "GADBannerView.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GADBannerViewDelegate>
{
    CGPoint _defaultPosition;
	CGPoint _lastTouchLocation;
    
    BOOL _isTouchHandled;
}

@property (nonatomic, retain) RootViewController *controller;

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) scene;
+ (CGPoint) locationFromTouch:(UITouch*)touch;
+ (HelloWorldLayer *)sharedHelloScene;
- (void)setIsTouchedLayer:(BOOL)isTouched;
- (void)reset;
- (void)setAdIsHidden:(BOOL)isHidden;

@end
