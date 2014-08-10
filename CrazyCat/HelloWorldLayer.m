//
//  HelloWorldLayer.m
//  CrazyCat
//
//  Created by zhaozilong on 14-7-24.
//  Copyright __MyCompanyName__ 2014年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "ZZCircle.h"
#import "ZZCat.h"
#import "Helper/AssetHelper.h"
#import "StartLayer.h"
#import "EndingLayer.h"

@interface HelloWorldLayer () {
    
    CCMenu *_menu;
    CCMenuItem *_homeItem;
}

@property (nonatomic, retain) NSMutableArray *circleMutableArray;
@property (nonatomic, retain) NSMutableArray *pathNodeMutableArray;

@property (nonatomic, retain) ZZCat *crazyCat;

@property (assign) int stepNum;

@property (nonatomic, retain) GADBannerView *adView;

//@property BOOL isCrazyMode;


@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

static HelloWorldLayer *instanceOfHelloScene;

- (void)dealloc {
    
    instanceOfHelloScene = nil;
    
    [_adView release];
    [_controller.view removeFromSuperview];
    [_controller release];
    
    [super dealloc];
}

+ (HelloWorldLayer *)sharedHelloScene {
    NSAssert(instanceOfHelloScene != nil, @"HelloScene instance not yet initialized!");
	return instanceOfHelloScene;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        instanceOfHelloScene = self;
        
//        //假设不会一开是就出现完胜或疯狂模式
//        self.isCrazyMode = NO;
        
        //步数
        self.stepNum = 0;
        
        //加载帧到缓存
        CCSpriteFrameCache *framCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [framCache addSpriteFramesWithFile:[AssetHelper getDeviceSpecificFileNameFor:@"CrazyCat.plist"]];
        
//        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLayerColor *color = [CCLayerColor layerWithColor:ccc4(102, 102, 102, 255)];
        [self addChild:color];
        
        CCSprite *backSprite = [CCSprite spriteWithSpriteFrameName:@"Backgroud.png"];
        [self addChild:backSprite];
        backSprite.anchorPoint = ccp(0.5, 1.0);
        backSprite.position = ccp(winSize.width / 2, winSize.height);
        
        
        _circleMutableArray = [[NSMutableArray alloc] init];
        int count = NUM_OF_COLUM * NUM_OF_COLUM;
        for (int i = 0; i < count; i++) {
            ZZCircle *circle = [ZZCircle circleWithSquareIndex:i parentNode:self isBlank:YES];
            [_circleMutableArray addObject:circle];
        }
        
        //设置初始位置
        [self randomInitalUnblankPosition];
        
        _crazyCat = [[ZZCat alloc] initWithIndex:0];
        [self addChild:_crazyCat.catSprite];
        int startIndex = INDEX_CIRCLE_START;
        ZZCircle *startCircle = [_circleMutableArray objectAtIndex:startIndex];
        _crazyCat.circleIndex = startIndex;
        [_crazyCat setPositionOfCat:startCircle.positionOfCircle];
        [_crazyCat playCatAnimationWithType:ZZCatAnimateNormal];
      
        //用来存放路径
        _pathNodeMutableArray = [[NSMutableArray alloc] init];
        
        //加开始界面
        StartLayer *sLayer = [StartLayer node];
        [self addChild:sLayer z:self.zOrder + 1];
        sLayer.tag = ZZStartLayerTag;
        self.isTouchEnabled = NO;
        
        //加返回按钮
        CCSprite *homeSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Home.png"];
        CCSprite *homeHLSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Home_HL.png"];
        _homeItem = [CCMenuItemSprite itemFromNormalSprite:homeSprite selectedSprite:homeHLSprite target:self selector:@selector(homeBtnPressed)];
        _homeItem.anchorPoint = ccp(0, 1.0);
        _homeItem.position = ccp(10, winSize.height - 10);
        
        _menu = [CCMenu menuWithItems:_homeItem, nil];
        [self addChild:_menu z:self.zOrder + 2];
        _menu.position = ccp(0, 0);
        
        [self setIsTouchedLayer:NO];
        
        
        //加入广告
        if (![ZZPublic isHiddenAd]) {
            [self addAdMob];
        }
        
        
	}
	return self;
}

- (void)setIsTouchedLayer:(BOOL)isTouched {
    if (isTouched) {
        self.isTouchEnabled = YES;
        _menu.isTouchEnabled = YES;
        [_menu setVisible:YES];
    } else {
        self.isTouchEnabled = NO;
        _menu.isTouchEnabled = NO;
        [_menu setVisible:NO];
    }
}

- (void)homeBtnPressed {
    
    //播放音效
    [ZZPublic playEffectWithType:EffectStart];
    
    //重置游戏
    [self reset];
    
    //显示主页
    StartLayer *sLayer = (StartLayer *)[self getChildByTag:ZZStartLayerTag];
    [sLayer showStartLayer];
}

- (void)randomInitalUnblankPosition {
    int randomNum = [HelloWorldLayer randomBetweenSmallNum:9 bigNum:16];
    
    NSMutableArray *numArray = [[NSMutableArray alloc] init];
    NSMutableArray *newNumArray = [[NSMutableArray alloc] init];
    
    int count = NUM_OF_COLUM * NUM_OF_COLUM;
    for (int i = 0; i < count; i++) {
        [numArray addObject:[NSNumber numberWithInt:i]];
    }
    
    for (int i = 0; i < randomNum; i++) {
        int num = [HelloWorldLayer randomBetweenSmallNum:0 bigNum:numArray.count - 1];
        NSNumber *delNum = [numArray objectAtIndex:num];
        //初始位置时，不能随机到40号码
        if (delNum.intValue != INDEX_CIRCLE_START) {
            [newNumArray addObject:delNum];
        }
        
        [numArray removeObjectAtIndex:num];
        
        
    }
    
    [numArray release];
    
    for (NSNumber *num in newNumArray) {
        int circleIndex = [num intValue];
        ZZCircle *circle = [_circleMutableArray objectAtIndex:circleIndex];
        [circle setCircleBlank:NO];
    }
}

+ (int)randomBetweenSmallNum:(int)smallNum bigNum:(int)bigNum {
    NSAssert(bigNum > 0, @"low不能小于等于0");
    
    int diff = bigNum - smallNum;
    
    int randomNum = arc4random() % diff;
    
    return randomNum + smallNum;
}

//计算最短路径，广度优先搜索。
- (void) findShortestWayWithLayer:(int)treeLayer {
    
    if (_pathNodeMutableArray.count == 0) {
        int circlrIndex = _crazyCat.circleIndex;
        ZZCircle *curCircle = [_circleMutableArray objectAtIndex:circlrIndex];
        [_pathNodeMutableArray addObject:curCircle];
        
        //第一个的层数是1
        curCircle.treeLayer = treeLayer;
    }
    
//    NSMutableArray *tempPathNodeMutableArray = [[NSMutableArray alloc] init];
    NSMutableSet *tempPathNodeSet = [[NSMutableSet alloc] init];
    
//    NSMutableArray *indexMutableArray = [[NSMutableArray alloc] init];
    ZZCircle *shortestCircle = nil;
    for (ZZCircle *parentCircle in _pathNodeMutableArray) {
        
        int curIndex = [parentCircle curCircleIndex];
        
        int circleColumNum = NUM_OF_COLUM;
        
        //遍历周围的8个格子
        int colum = curIndex % circleColumNum + 1;//1~9
        int row = curIndex / circleColumNum + 1;//1~9
        
        //左
        int left = colum - 1;
        if (left > 0) {
            
            [self isFindWithRow:row colum:left parent:parentCircle tempArray:tempPathNodeSet treeLayer:treeLayer];
            
        } else {
            CCLOG(@"找到最短路径了。。。");
            shortestCircle = parentCircle;
            break;
        }
        
        
        //右
        int right = colum + 1;
        if (right <= circleColumNum) {
            
            [self isFindWithRow:row colum:right parent:parentCircle tempArray:tempPathNodeSet treeLayer:treeLayer];
        } else {
            CCLOG(@"找到最短路径了。。。");
            shortestCircle = parentCircle;
            break;
        }
        
        //上
        int up = row + 1;
        if (up <= circleColumNum) {
            
            [self isFindWithRow:up colum:colum parent:parentCircle tempArray:tempPathNodeSet treeLayer:treeLayer];

        } else {
            CCLOG(@"找到最短路径了。。。");
            shortestCircle = parentCircle;
            break;
        }
        
        //下
        int down = row - 1;
        if (down > 0) {
            [self isFindWithRow:down colum:colum parent:parentCircle tempArray:tempPathNodeSet treeLayer:treeLayer];
            
        } else {
            CCLOG(@"找到最短路径了。。。");
            shortestCircle = parentCircle;
            break;
        }
        
        if (row % 2 == 0) {
            //上左，row为奇数时，不选
            int upLeft = colum - 1;
            if (upLeft > 0) {
                
                [self isFindWithRow:up colum:upLeft parent:parentCircle tempArray:tempPathNodeSet treeLayer:treeLayer];
                
            } else {
                CCLOG(@"找到最短路径了。。。");
                shortestCircle = parentCircle;
                break;
            }
            
            //下左row为奇数时，不选
            int downLeft = colum - 1;
            
            if (downLeft > 0) {
                [self isFindWithRow:down colum:downLeft parent:parentCircle tempArray:tempPathNodeSet treeLayer:treeLayer];
            } else {
                CCLOG(@"找到最短路径了。。。");
                shortestCircle = parentCircle;
                break;
            }
        } else {
            //上右row为偶数时，不选
            int upRight = colum + 1;
            if (upRight <= circleColumNum) {
                
                [self isFindWithRow:up colum:upRight parent:parentCircle tempArray:tempPathNodeSet treeLayer:treeLayer];
                
            } else {
                CCLOG(@"找到最短路径了。。。");
                shortestCircle = parentCircle;
                break;
            }
            
            //下右row为偶数时，不选
            int downRight = colum + 1;
            
            if (downRight <= circleColumNum) {
                [self isFindWithRow:down colum:downRight parent:parentCircle tempArray:tempPathNodeSet treeLayer:treeLayer];
            } else {
                CCLOG(@"找到最短路径了。。。");
                shortestCircle = parentCircle;
                break;
            }

        }
    }
    
    if (shortestCircle != nil) {
        [_pathNodeMutableArray removeAllObjects];
        [tempPathNodeSet release];
        
        [self pointOutPathOfCatWith:shortestCircle];
        
    } else {
        
        if (tempPathNodeSet.count <= 0) {
            CCLOG(@"疯狂模式");
            [_crazyCat playCatAnimationWithType:ZZCatAnimateCrazy];
            [_pathNodeMutableArray removeAllObjects];
            [tempPathNodeSet release];
            
            //进入疯狂模式
            [self crazyMode];
            
        } else {
            [_pathNodeMutableArray removeAllObjects];
            [_pathNodeMutableArray addObjectsFromArray:tempPathNodeSet.allObjects];
            [tempPathNodeSet release];
            
            [self findShortestWayWithLayer:treeLayer+1];
        }
    }
    
}

- (void)crazyMode {
    int curIndex = _crazyCat.circleIndex;
    
    //疯狂模式后增加的步数
    self.stepNum++;
    CCLOG(@"第%d步", self.stepNum);
    
    int circleColumNum = NUM_OF_COLUM;
    
    //遍历周围的8个格子
    int colum = curIndex % circleColumNum + 1;//1~9
    int row = curIndex / circleColumNum + 1;//1~9
    
    //左
    int left = colum - 1;
    BOOL isLeft = [self isFindWithRow:row colum:left];
    
    //右
    int right = colum + 1;
    BOOL isRight = [self isFindWithRow:row colum:right];
    
    //上
    int up = row + 1;
    BOOL isUp = [self isFindWithRow:up colum:colum];
    
    //下
    int down = row - 1;
    BOOL isDown = [self isFindWithRow:down colum:colum];
    
    if (row % 2 == 0) {
        //上左，row为奇数时，不选
        int upLeft = colum - 1;
        BOOL isUpLeft = [self isFindWithRow:up colum:upLeft];
        
        //下左row为奇数时，不选
        int downLeft = colum - 1;
        BOOL isDownLeft = [self isFindWithRow:down colum:downLeft];
        
        if (!isLeft && !isRight && !isUp && !isDown && !isUpLeft && !isDownLeft) {
            CCLOG(@"完全胜利");
            
            [self successOrLose:YES];
            
            //播放音效
            [ZZPublic playEffectWithType:EffectWin];
        } else {
            //播放音效
            [ZZPublic playEffectWithType:EffectCrazy];
        }
    } else {
        //上右row为偶数时，不选
        int upRight = colum + 1;
        BOOL isUpRight = [self isFindWithRow:up colum:upRight];
        
        //下右row为偶数时，不选
        int downRight = colum + 1;
        BOOL isDownRight = [self isFindWithRow:down colum:downRight];
        
        if (!isLeft && !isRight && !isUp && !isDown && !isUpRight && !isDownRight) {
            CCLOG(@"完全胜利");
            
            [self successOrLose:YES];
            
            //播放音效
            [ZZPublic playEffectWithType:EffectWin];
        } else {
            //播放音效
            [ZZPublic playEffectWithType:EffectCrazy];
        }
        
    }
}

- (BOOL)isFindWithRow:(int)row colum:(int)colum {
    int confirmIndex = (row - 1) * NUM_OF_COLUM + colum - 1;
    
    ZZCircle *childCircle = [_circleMutableArray objectAtIndex:confirmIndex];
    if (childCircle.isBlank) {
        [_crazyCat setPositionOfCat:childCircle.positionOfCircle];
        _crazyCat.circleIndex = [childCircle curCircleIndex];
        
        return YES;
    }
    
    return NO;
}

- (void)isFindWithRow:(int)row colum:(int)colum parent:(ZZCircle *)parentCircle tempArray:(NSMutableSet *)tempPathNodeSet treeLayer:(int)treeLayer {
    
    int confirmIndex = (row - 1) * NUM_OF_COLUM + colum - 1;
    
    //把路径记录下来。
    ZZCircle *childCircle = [_circleMutableArray objectAtIndex:confirmIndex];
    int parentLayer = parentCircle.treeLayer;
    int childLayer = childCircle.treeLayer;
    
    if (!childCircle.isBlank || (parentLayer >= childLayer && childLayer != 0)) {
        return;
    }
    
    [tempPathNodeSet addObject:childCircle];
    childCircle.treeLayer = treeLayer+1;
    
    [parentCircle.childrenSet addObject:[NSNumber numberWithInt:[childCircle curCircleIndex]]];
    [childCircle.parentSet addObject:[NSNumber numberWithInt:[parentCircle curCircleIndex]]];
}

- (void)pointOutPathOfCatWith:(ZZCircle *)childCircle {
    NSMutableArray *parentCircles = [NSMutableArray arrayWithArray:childCircle.parentSet.allObjects];
    
    if (parentCircles.count > 0) {
        int parentIndex = [[parentCircles objectAtIndex:0] intValue];
        ZZCircle *parentCircle = [_circleMutableArray objectAtIndex:parentIndex];
        
        
        
        if (parentCircle.parentSet.count <= 0) {
            //清空现场
            [self clearInfoOfCircles];
            
            //下一步要走的是，把CrazyCat移动到这里
            CCLOG(@"下一步要走的是%d", [childCircle curCircleIndex]);
            [_crazyCat setPositionOfCat:childCircle.positionOfCircle];
            _crazyCat.circleIndex = [childCircle curCircleIndex];
            self.stepNum++;
            
            //播放音效
            [ZZPublic playEffectWithType:EffectNormal];
            CCLOG(@"第%d步", self.stepNum);
            
            return;
        }
        
        CCLOG(@"%d,", [childCircle curCircleIndex]);
        
        [self pointOutPathOfCatWith:parentCircle];
        
        
    } else {
        CCLOG(@"神经猫逃走了");
        
        [self successOrLose:NO];
        
        //播放音效
        [ZZPublic playEffectWithType:EffectLose];
    }
    
}

- (void)clearInfoOfCircles {
    for (ZZCircle *circle in _circleMutableArray) {
        [circle.parentSet removeAllObjects];
        [circle.childrenSet removeAllObjects];
        circle.treeLayer = 0;
    }
}

- (void)successOrLose:(BOOL)isSuccess {
    [self setIsTouchedLayer:NO];
    EndingLayer *layer = [[[EndingLayer alloc] initWithSteps:self.stepNum success:isSuccess] autorelease];
    [self addChild:layer z:self.zOrder+1 tag:ZZEndingLayerTag];
    
}

- (void)reset {
    for (ZZCircle *circle in _circleMutableArray) {
        [circle.parentSet removeAllObjects];
        [circle.childrenSet removeAllObjects];
        circle.treeLayer = 0;
        [circle setCircleBlank:YES];
    }
    
    _crazyCat.circleIndex = INDEX_CIRCLE_START;
    ZZCircle *circle = [_circleMutableArray objectAtIndex:_crazyCat.circleIndex];
    _crazyCat.catSprite.position = circle.positionOfCircle;
    [_crazyCat playCatAnimationWithType:ZZCatAnimateNormal];
    
    //设置初始位置
    [self randomInitalUnblankPosition];
    
    self.stepNum = 0;
    
}

+ (CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    _lastTouchLocation = [HelloWorldLayer locationFromTouch:touch];
    BOOL isTouchCircle = NO;
    for (ZZCircle *circle in self.circleMutableArray) {
        if (CGRectContainsPoint(circle.circleSprite.boundingBox, _lastTouchLocation) && circle.isBlank) {
            isTouchCircle = YES;
            break;
        }
    }
    
    if (isTouchCircle) {
        _isTouchHandled = YES;
    }
    
    return _isTouchHandled;
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint endPoint = [HelloWorldLayer locationFromTouch:touch];
    
    ZZCircle *currCircle = nil;
    BOOL isTouchCircle = NO;
    for (ZZCircle *circle in self.circleMutableArray) {
        if (CGRectContainsPoint(circle.circleSprite.boundingBox, _lastTouchLocation) && CGRectContainsPoint(circle.circleSprite.boundingBox, endPoint) && circle.isBlank) {
            isTouchCircle = YES;
            currCircle = circle;
            break;
        }
    }
    
    if (isTouchCircle) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Touched.png"];
        [currCircle.circleSprite setDisplayFrame:frame];
        currCircle.isBlank = NO;
        
        
        
        [self findShortestWayWithLayer:1];
    }
    
}

- (void)registerWithTouchDispatcher {
    //touch is enabled
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-100 swallowsTouches:YES];
}

#pragma mark-
#pragma mark admob
- (void)addAdMob {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //加一个UIViewController
    _controller = [[RootViewController alloc] init];
    _controller.view.frame = CGRectMake(0,0,winSize.width,winSize.height);
    [[[CCDirector sharedDirector] openGLView]addSubview : _controller.view];
    
    //    //判断网络状态
    //	NetworkStatus NetStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    //    //没有网的情况
    //	if (NetStatus == NotReachable) return;
    
    //有网络的情况下加载广告条
    if ([ZZPublic isiPad]) {
        _adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    } else {
        _adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    }
    
    _adView.rootViewController = _controller;
    //    _adView.delegate = self;
    _adView.adUnitID = ADMOB_ID;
    
    //设置广告条的位置
    CGPoint point = CGPointMake(winSize.width / 2, winSize.height - _adView.frame.size.height / 2);
    _adView.center = point;
    
    [_adView loadRequest:[GADRequest request]];
    
    [_controller.view addSubview:_adView];
    [_adView setHidden:YES];
    
    
    
    //在广告条没有加载出来之前，显示自己的广告条
    //    UIImageView *imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OfflineAds01.png"]] autorelease];
    //    CGRect imgFrame = imgView.frame;
    //    imgFrame.origin = CGPointMake(0, self.mainTableView.frame.origin.y + self.mainTableView.frame.size.height + height);
    //    [imgView setFrame:imgFrame];
    //    [self.view insertSubview:imgView belowSubview:self.mainTableView];
    //    imgView.tag = TAG_OFFLINE_ADBANNER;
}

- (void)setAdIsHidden:(BOOL)isHidden {
    if ([ZZPublic isHiddenAd]) {
        return;
    }
    [_adView setHidden:isHidden];
}

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    [view setHidden:YES];
    //先删除本地广告条
    //    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:TAG_OFFLINE_ADBANNER];
    //    if (imgView) {
    //        [imgView removeFromSuperview];
    //    }
    //
    //    [self.view insertSubview:view belowSubview:self.mainTableView];
}

@end
