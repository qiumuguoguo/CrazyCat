//
//  ZZCircle.h
//  CrazyCat
//
//  Created by zhaozilong on 14-7-24.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ZZCircle : NSObject {
//    CGPoint _defaultPosition;
//	CGPoint _lastTouchLocation;
//    
//    BOOL _isTouchHandled;
}

@property int treeLayer;

@property (nonatomic, retain) CCSprite *circleSprite;
@property (nonatomic, retain) NSMutableSet *parentSet;
@property (nonatomic, retain) NSMutableSet *childrenSet;

@property BOOL isBlank;

+ (ZZCircle *)circleWithSquareIndex:(int)index parentNode:(CCNode *)parent isBlank:(BOOL)isBlank;

- (CGPoint)positionOfCircle;

- (int)curCircleIndex;

- (void)setCircleBlank:(BOOL)isBlank;

@end
