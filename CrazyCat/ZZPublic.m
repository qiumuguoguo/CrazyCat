//
//  ZZPublic.m
//  CrazyCat
//
//  Created by zhaozilong on 14-7-27.
//
//

#import "ZZPublic.h"

@implementation ZZPublic

+ (BOOL)isiPad {
    
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

+ (BOOL)isiPhone5 {
    return ([[UIScreen mainScreen] bounds].size.height == 568.000000);
}

#define kIsEnabledSoundEffect @"kIsEnabledSoundEffect"
+ (BOOL)isEnabledSoundEffect {
    BOOL isEnabledSound = [[NSUserDefaults standardUserDefaults] boolForKey:kIsEnabledSoundEffect];
    return isEnabledSound;
}

+ (void)setIsEnabledSoundEffect:(BOOL)isEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:isEnabled forKey:kIsEnabledSoundEffect];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)preloadSoundEffect {
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_NORMAL_0];
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_NORMAL_1];
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_CRAZY_0];
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_CRAZY_1];
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_CRAZY_2];
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_WIN];
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_LOSE];
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_START];
    [[SimpleAudioEngine sharedEngine] preloadEffect:EFFECT_TAP];
}

+ (void)unloadSoundEffect {
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_NORMAL_0];
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_NORMAL_1];
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_CRAZY_0];
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_CRAZY_1];
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_CRAZY_2];
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_WIN];
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_LOSE];
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_START];
    [[SimpleAudioEngine sharedEngine] unloadEffect:EFFECT_TAP];
    
}

+ (void)playEffectWithType:(EffectType)type {
    
    if (![ZZPublic isEnabledSoundEffect]) {
        return;
    }
    
    switch (type) {
        case EffectNormal:
            [ZZPublic playNormalEffect];
            break;
            
        case EffectCrazy:
            [ZZPublic playCrazyEffect];
            break;
            
        case EffectWin:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_WIN];
            break;
            
        case EffectLose:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_LOSE];
            break;
            
        case EffectStart:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_START];
            break;
            
        case EffectTap:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_TAP];
            break;
            
        default:
            NSAssert(NO, @"没有正确的音效");
            break;
    }
    
}

+ (void)playNormalEffect {
    int randomNum = arc4random() % 10;
    switch (randomNum) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_NORMAL_0];
            break;
            
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_NORMAL_1];
            break;
            
        case 2:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_LOSE];
            break;
    
        default:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_TAP];
            break;
    }
}

+ (void)playCrazyEffect {
    int randomNum = arc4random() % 10;
    switch (randomNum) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_CRAZY_0];
            break;
            
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_CRAZY_1];
            break;
            
        case 2:
        case 8:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_CRAZY_2];
            break;
            
        default:
            [[SimpleAudioEngine sharedEngine] playEffect:EFFECT_TAP];
            break;
    }
}

+ (ALint)playSuccessEffect {
    ALint soundInt = 0;
    if ([ZZPublic isEnabledSoundEffect]) {
        soundInt = [[SimpleAudioEngine sharedEngine] playEffect:@"Success.mp3"];
    }
    
    return soundInt;
}

#pragma mark - First Time Run

//程序是否第一次安装运行
#define kIsFirstTimeInstall @"kIsFirstTimeInstall"
+ (BOOL)isFirstTimeInstallApplication {
    BOOL  hasRunBefore = [[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstTimeInstall];
    if (!hasRunBefore) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFirstTimeInstall];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    
    return NO;
}

//此版本是否第一次运行
+ (BOOL)isThisVersionFirstTimeRun {
    NSString *version = [ZZPublic buildVersion];
    BOOL  hasRunBefore = [[NSUserDefaults standardUserDefaults] boolForKey:version];
    
    if (!hasRunBefore) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:version];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    
    return NO;
}

+ (NSString *)buildVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow(infoDictionary);
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build;
}

#define kIsHiddenAd @"kIsHiddenAd"
+ (BOOL)isHiddenAd {
    BOOL isHiddenAd = [[NSUserDefaults standardUserDefaults] boolForKey:kIsHiddenAd];
    return isHiddenAd;
}

+ (void)setIsHiddenAd:(BOOL)isHidden {
    [[NSUserDefaults standardUserDefaults] setBool:isHidden forKey:kIsHiddenAd];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
