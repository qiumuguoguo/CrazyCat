//
//  ZZCircle.m
//  CrazyCat
//
//  Created by zhaozilong on 14-7-24.
//
//

#import "ZZCircle.h"
//#import "HelloWorldLayer.h"

@interface ZZCircle () {
    
}

@property int circleIndex;

@end

@implementation ZZCircle

- (void)dealloc {
    [super dealloc];
    
    [_parentSet release], _parentSet = nil;
    [_childrenSet release], _childrenSet = nil;
}

+ (ZZCircle *)circleWithSquareIndex:(int)index parentNode:(CCNode *)parent isBlank:(BOOL)isBlank {
    return [[[self alloc] initWithSquareIndex:index parentNode:parent isBlank:isBlank] autorelease];
}

//Index从0开始
- (id)initWithSquareIndex:(int)index parentNode:(CCNode *)parent isBlank:(BOOL)isBlank {
    
    self = [super init];
    if (self) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        _treeLayer = 0;
        
        _parentSet = [[NSMutableSet alloc] init];
        _childrenSet = [[NSMutableSet alloc] init];
        
        self.isBlank = isBlank;
    
        _circleIndex = index;
        
        CGFloat circleWidth = WIDTH_OF_CIRCLE;
        int circleColumNum = NUM_OF_COLUM;
        
        self.circleSprite = [CCSprite spriteWithSpriteFrameName:@"Blank.png"];
        self.circleSprite.scale = circleWidth / self.circleSprite.boundingBox.size.width;
        if (!self.isBlank) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Touched.png"];
            [self.circleSprite setDisplayFrame:frame];
        }
        
        [parent addChild:self.circleSprite];
        
        
        CGFloat fixedPosX = (winSize.width - (NUM_OF_COLUM + 1) * WIDTH_OF_CIRCLE) / 2;
        CGFloat fixedPosY = 60.0f;
        
        if ([ZZPublic isiPad]) {
            fixedPosY = 85.0f;
        } else if ([ZZPublic isiPhone5]) {
            fixedPosY = 90.0f;
        } else {
            fixedPosY = 60.0f;
        }
        
        int colum = index % circleColumNum + 1;
        int row = index / circleColumNum + 1;
        
        CGFloat posX = colum * circleWidth + fixedPosX;
        CGFloat posY = row * circleWidth + fixedPosY;
        
        if (row % 2 == 0) {
            posX = posX - (circleWidth / 4);
        } else {
            posX = posX + (circleWidth / 4);
        }
        
        self.circleSprite.position = ccp(posX, posY);

    }
    
    return self;
}

- (CGPoint)positionOfCircle {
    return self.circleSprite.position;
}

- (int)curCircleIndex {
    return self.circleIndex;
}

- (void)setCircleBlank:(BOOL)isBlank {
    self.isBlank = isBlank;
    
    NSString *name = nil;
    
    if (isBlank) {
        name = @"Blank.png";
    } else {
        name = @"Touched.png";
    }
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    [self.circleSprite setDisplayFrame:frame];
}





@end
