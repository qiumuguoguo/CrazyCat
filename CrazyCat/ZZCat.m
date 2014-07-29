//
//  ZZCat.m
//  CrazyCat
//
//  Created by zhaozilong on 14-7-24.
//
//

#import "ZZCat.h"
#import "Helper/CCAnimationHelper.h"

#define TAG_ANIMATE_NORMAL 1001
#define TAG_ANIMATE_CRAZY 1002

@interface ZZCat () {
    
}

//@property (nonatomic, retain) CCSprite *catSprite;

@end

@implementation ZZCat

//+ (ZZCat *)catWithIndex:(int)index {
//    return [[[self alloc] initWithIndex:index] autorelease];
//}

- (id)initWithIndex:(int)index {
    
    self = [super init];
    if (self) {
        CGFloat circleWidth = WIDTH_OF_CIRCLE;
        
        self.catSprite = [CCSprite spriteWithSpriteFrameName:@"Normal0.png"];
        self.catSprite.scale = circleWidth / self.catSprite.boundingBox.size.width;
        self.catSprite.anchorPoint = ccp(0.5, 0.2);
        
    }
    return self;
}

- (void)setPositionOfCat:(CGPoint)point {
    self.catSprite.position = point;
}

- (void)playCatAnimationWithType:(ZZCatAnimateType)catType {
    
    NSString *animateName = nil;
    int tag, frameCount;
    CGFloat delay;
    
    if (catType == ZZCatAnimateNormal) {
        
        frameCount = 4;
        delay = 0.22;
        tag = TAG_ANIMATE_NORMAL;
        animateName = @"Normal";
        
    } else {
        
        frameCount = 4;
        delay = 0.15;
        tag = TAG_ANIMATE_CRAZY;
        animateName = @"Crazy";
    }
    
    [self.catSprite stopActionByTag:TAG_ANIMATE_NORMAL];
    [self.catSprite stopActionByTag:TAG_ANIMATE_CRAZY];
    
    CCAnimation *selectedAnim = [CCAnimation animationWithFrame:animateName frameCount:frameCount delay:delay];
    CCAnimate *selectedAnimate = [CCAnimate actionWithAnimation:selectedAnim];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:selectedAnimate];
    repeat.tag = tag;
    [self.catSprite runAction:repeat];
    
}




@end
