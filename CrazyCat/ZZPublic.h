//
//  ZZPublic.h
//  CrazyCat
//
//  Created by zhaozilong on 14-7-27.
//
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

#define EFFECT_CRAZY_0  @"Effect_Crazy0.caf"
#define EFFECT_CRAZY_1  @"Effect_Crazy1.caf"
#define EFFECT_CRAZY_2  @"Effect_Crazy2.caf"
#define EFFECT_NORMAL_0 @"Effect_Normal0.caf"
#define EFFECT_NORMAL_1 @"Effect_Normal1.caf"
#define EFFECT_LOSE     @"Effect_Lose.caf"
#define EFFECT_WIN      @"Effect_Win.caf"
#define EFFECT_START    @"Effect_Start.caf"
#define EFFECT_TAP      @"Effect_Tap.caf"

#define IOS_NEWER_OR_EQUAL_TO_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

typedef enum {
    EffectNormal,
    EffectCrazy,
    EffectWin,
    EffectLose,
    EffectStart,
    EffectTap,
    EffectNone,
}EffectType;


@interface ZZPublic : NSObject

+ (BOOL)isiPad;
+ (BOOL)isiPhone5;
+ (BOOL)isEnabledSoundEffect;
+ (void)setIsEnabledSoundEffect:(BOOL)isEnabled;
+ (void)preloadSoundEffect;
+ (void)unloadSoundEffect;
//+ (ALint)playSuccessEffect;
+ (void)playEffectWithType:(EffectType)type;

+ (BOOL)isFirstTimeInstallApplication;
//此版本是否第一次运行
+ (BOOL)isThisVersionFirstTimeRun;
+ (NSString *)buildVersion;

+ (BOOL)isHiddenAd;
+ (void)setIsHiddenAd:(BOOL)isHidden;

@end
