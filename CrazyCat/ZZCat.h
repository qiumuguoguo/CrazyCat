//
//  ZZCat.h
//  CrazyCat
//
//  Created by zhaozilong on 14-7-24.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    ZZCatAnimateNormal,
    ZZCatAnimateCrazy,
    ZZCatAnimateNone,
}ZZCatAnimateType;

@interface ZZCat : NSObject

@property (nonatomic, retain) CCSprite *catSprite;

@property (assign) int circleIndex;

//+ (ZZCat *)catWithIndex:(int)index;
- (id)initWithIndex:(int)index;

- (void)setPositionOfCat:(CGPoint)point;

- (void)playCatAnimationWithType:(ZZCatAnimateType)catType;

@end
