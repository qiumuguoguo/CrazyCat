//
//  EndingLayer.m
//  CrazyCat
//
//  Created by zhaozilong on 14-7-25.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "EndingLayer.h"
#import <ShareSDK/ShareSDK.h>
#import "ZZAcquirePath.h"
#import "AssetHelper.h"
#import "HelloWorldLayer.h"

#define CONTENT NSLocalizedString(@"我正在玩电影海报猜猜猜，遇到了一个难猜的海报，快来帮我看看是什么电影啊。详情见官网http://sharesdk.cn @TAD", @"分享内容")

//所有的位置坐标
typedef struct ItemSharePostion {
    
    CGPoint Weixin;
    CGPoint PYQ;
    CGPoint WeiBo;
    
    CGPoint replay;
    CGPoint board;
    CGPoint words;
    
    CGSize wordSize;
    
}ItemSharePostionSet;

@interface EndingLayer () {
    ItemSharePostionSet _ISPSet;
    CCMenu *_menu;
}

//@property (assign)ShareBoradShareType SBStype;

@property (nonatomic, retain)NSString *shareContent;
@property (assign) BOOL isSuccess;

@end


@implementation EndingLayer

- (void)dealloc {
    
    CCLOG(@"ShareBorad is dealloc");
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:[AssetHelper getDeviceSpecificFileNameFor:@"EndingPage.plist"]];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [super dealloc];
}

- (id)initWithSteps:(int)num success:(BOOL)isSuccess {
    self = [super init];
    if (self) {
        
        self.isTouchEnabled = YES;
        
        self.isSuccess = isSuccess;
        
        //加载帧到缓存
        CCSpriteFrameCache *framCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [framCache addSpriteFramesWithFile:[AssetHelper getDeviceSpecificFileNameFor:@"EndingPage.plist"]];
        
        //设置初始位置
        [self setItemInitalPostion];
        
        CCSprite *boradSprite = [CCSprite spriteWithSpriteFrameName:@"Borad.png"];
        [self addChild:boradSprite];
        boradSprite.position = _ISPSet.board;
        boradSprite.anchorPoint = ccp(0.5, 1);
        
        if ([ZZPublic isiPad]) {
            _ISPSet.wordSize = CGSizeMake(boradSprite.boundingBox.size.width - 50, boradSprite.boundingBox.size.height - 30);
        } else {
            _ISPSet.wordSize = CGSizeMake(boradSprite.boundingBox.size.width - 25, boradSprite.boundingBox.size.height - 20);
        }
        
        if (isSuccess) {
            [self setInfoWithSteps:num];
        } else {
            _shareContent = [NSString stringWithFormat:@"失败！神经兔跑了，以后再也不用吃药啦！快分享给朋友们一起通缉他！"];
        }
        CCLabelTTF *labelTitle = [CCLabelTTF labelWithString:_shareContent dimensions:_ISPSet.wordSize alignment:NSTextAlignmentLeft vertAlignment:CCVerticalAlignmentTop lineBreakMode:NSLineBreakByCharWrapping fontName:@"STHeitiSC-Medium" fontSize:([ZZPublic isiPad] ? 40.0f : 20.0f)];
        
        labelTitle.color = ccBLACK;
        labelTitle.anchorPoint = ccp(0.5, 1);
        [self addChild:labelTitle];
        labelTitle.position = _ISPSet.words;
        
        CCSprite *replaySprite = [CCSprite spriteWithSpriteFrameName:@"Button_Replay.png"];
        CCSprite *replayHLSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Replay_HL.png"];
        CCMenuItem *replayItem = [CCMenuItemImage itemFromNormalSprite:replaySprite selectedSprite:replayHLSprite target:self selector:@selector(replayBtnPressed)];
        replayItem.anchorPoint = ccp(0.5, 0.5);
        
        //朋友圈
        CCSprite *PYQSprite = [CCSprite spriteWithSpriteFrameName:@"Share_PYQ.png"];
        CCSprite *PYQHLSprite = [CCSprite spriteWithSpriteFrameName:@"Share_PYQ_HL.png"];
        CCMenuItem *PYQItem = [CCMenuItemImage itemFromNormalSprite:PYQSprite selectedSprite:PYQHLSprite target:self selector:@selector(shareToPYQ)];
        PYQItem.anchorPoint = ccp(0.5, 0.5);
        
        //微信
        CCSprite *WXSprite = [CCSprite spriteWithSpriteFrameName:@"Share_WX.png"];
        CCSprite *WXHLSprite = [CCSprite spriteWithSpriteFrameName:@"Share_WX_HL.png"];
        CCMenuItem *WXItem = [CCMenuItemImage itemFromNormalSprite:WXSprite selectedSprite:WXHLSprite target:self selector:@selector(shareToWeiXin)];
        WXItem.anchorPoint = ccp(0.5, 0.5);
        
        //微博
        CCSprite *WBSprite = [CCSprite spriteWithSpriteFrameName:@"Share_WB.png"];
        CCSprite *WBHLSprite = [CCSprite spriteWithSpriteFrameName:@"Share_WB_HL.png"];
        CCMenuItem *WBItem = [CCMenuItemImage itemFromNormalSprite:WBSprite selectedSprite:WBHLSprite target:self selector:@selector(shareToSinaWeiBo)];
        WBItem.anchorPoint = ccp(0.5, 0.5);
        
        _menu = [CCMenu menuWithItems:PYQItem, WXItem, WBItem, replayItem, nil];
        _menu.position = ccp(0, 0);
        [self addChild:_menu];
        
        replayItem.position = _ISPSet.replay;
        PYQItem.position = _ISPSet.PYQ;
        WXItem.position = _ISPSet.Weixin;
        WBItem.position = _ISPSet.WeiBo;
        
    }
    return self;
}

- (void)setItemInitalPostion {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    if ([ZZPublic isiPad]) {
        _ISPSet.PYQ = ccp(winSize.width / 2 - 140, 420);
        _ISPSet.Weixin = ccp(winSize.width / 2, 420);
        _ISPSet.WeiBo = ccp(winSize.width / 2 + 140, 420);
        
        _ISPSet.replay = ccp(winSize.width / 2, 250);
        _ISPSet.board = ccp(winSize.width / 2, winSize.height - 250);
        _ISPSet.words = ccp(winSize.width / 2, _ISPSet.board.y - 40);
    } else if ([ZZPublic isiPhone5]) {
        _ISPSet.PYQ = ccp(winSize.width / 2 - 70, 270);
        _ISPSet.Weixin = ccp(winSize.width / 2, 270);
        _ISPSet.WeiBo = ccp(winSize.width / 2 + 70, 270);
        
        _ISPSet.replay = ccp(winSize.width / 2, 180);
        _ISPSet.board = ccp(winSize.width / 2, winSize.height - 140);
        _ISPSet.words = ccp(winSize.width / 2, _ISPSet.board.y - 15);
    } else {
        _ISPSet.PYQ = ccp(winSize.width / 2 - 70, 210);//210
        _ISPSet.Weixin = ccp(winSize.width / 2, 210);
        _ISPSet.WeiBo = ccp(winSize.width / 2 + 70, 210);
        
        _ISPSet.replay = ccp(winSize.width / 2, 130);
        _ISPSet.board = ccp(winSize.width / 2, winSize.height - 120);
        _ISPSet.words = ccp(winSize.width / 2, _ISPSet.board.y - 15);
    }
    
}

- (void)replayBtnPressed {
    //播放音效
    [ZZPublic playEffectWithType:EffectStart];
    
    [[HelloWorldLayer sharedHelloScene] reset];
    [[HelloWorldLayer sharedHelloScene] setIsTouchedLayer:YES];
    [self removeFromParentAndCleanup:YES];
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN swallowsTouches:YES];
}

+ (CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [EndingLayer locationFromTouch:touch];
    BOOL isTouchHandled = YES;
    for (CCMenuItem *item in _menu.children) {
        if (CGRectContainsPoint(item.boundingBox, point)) {
            isTouchHandled = NO;
        }
    }
    
    return isTouchHandled;
}

- (void)shareToWeiXin {
    [self shareWithShareType:ShareTypeWeixiSession mediaType:SSPublishContentMediaTypeApp];
    
}

- (void)shareToPYQ {
    [self shareWithShareType:ShareTypeWeixiTimeline mediaType:SSPublishContentMediaTypeApp];
}

- (void)shareToSinaWeiBo {
    [self shareWithShareType:ShareTypeSinaWeibo mediaType:SSPublishContentMediaTypeText];
}

- (void)shareWithShareType:(ShareType)type mediaType:(SSPublishContentMediaType *)mediaType {
    //播放音效
    [ZZPublic playEffectWithType:EffectStart];
    
    NSString *imagePath = nil;
    NSString *content = nil;
    NSString *title = NSLocalizedString(@"TITLE_APP_NAME", nil);
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", APP_ID];
    NSString *urlStore = [NSString stringWithFormat:@"itunes.apple.com/app/id%@", APP_ID];
    
    imagePath = [ZZAcquirePath getBundleDirectoryWithFileName:@"Icon@2x.png"];
    
    if (!self.isSuccess) {
        _shareContent = @"围住神经兔iPhone&iPad版隆重上线，快来一起放弃治疗。";
    }
    content = [NSString stringWithFormat:@"%@%@", _shareContent, url];
    
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:title
                                                  url:urlStore
                                          description:nil
                                            mediaType:mediaType];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:type
                          container:nil
                            content:publishContent
                      statusBarTips:NO
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     CCLOG(@"%@", NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                     
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     CCLOG(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                 }
                             }];
    
    
}

- (void)setInfoWithSteps:(int)step {
    
    NSString *fixedStr = [NSString stringWithFormat:@"成功！用%d步抓到了神经兔！", step];
    
    if (step <= 3) {
        _shareContent = @"简直是神，终于可以出院了，再也不用治疗了。回家吧！";
    } else if (step <= 10) {
        _shareContent = @"也挺牛的了，努力一点也许就可以出院了，不要放弃治疗，很快就能回家了。";
    } else if (step <= 30) {
        _shareContent = @"说真的，你还是有救的，记得按时吃药，还有希望出院。";
    } else if (step <= 70) {
        _shareContent = @"恭喜你获得中国好神经称号，快去拯救太空吧，地球不适合你。";
    } else {
        _shareContent = @"放弃治疗吧，别吃药了，浪费钱。";
    }
    
    _shareContent = [NSString stringWithFormat:@"%@%@", fixedStr, _shareContent];
}

@end
