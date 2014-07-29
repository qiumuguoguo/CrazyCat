//
//  StartLayer.m
//  CrazyCat
//
//  Created by zhaozilong on 14-7-27.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "StartLayer.h"
#import "AssetHelper.h"
#import "HelloWorldLayer.h"

@interface StartLayer () {
    
    CCMenu *_menu;
    
    CCSprite *_catSprite;
    CCSprite *_logoSprite;
    
    CCMenuItem *_startItem;
    CCMenuItemToggle *_soundToggle;
    CCMenuItem *_rateItem;
    CCMenuItem *_adItem;
    CCMenuItem *_infoItem;
}

@property (nonatomic, retain) NSString *curInfo;

@property (nonatomic, retain) UIAlertView *indicator;

@end


@implementation StartLayer

- (void)dealloc {
    CCLOG(@"Start Layer release");
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        
//        self.isTouchEnabled = YES;
        
        //加载帧到缓存
        CCSpriteFrameCache *framCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [framCache addSpriteFramesWithFile:[AssetHelper getDeviceSpecificFileNameFor:@"MainPage.plist"]];
        
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [self initalPostion];
        
        //LOGO
        _catSprite = [CCSprite spriteWithSpriteFrameName:@"MainPageCat.png"];
        _catSprite.position = _SPSet.cat;
        _catSprite.anchorPoint = ccp(1.0, 0);
        [self addChild:_catSprite];
        
        _logoSprite = [CCSprite spriteWithSpriteFrameName:@"MainPageLogo.png"];
        _logoSprite.position = _SPSet.logo;
        _logoSprite.anchorPoint = ccp(0.5, 1.0);
        [self addChild:_logoSprite];
        
        //按钮设置
        [self initalMenu];
        
    }
    return self;
}

- (void)initalMenu {
    
    //开始
    CCSprite *startSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Start.png"];
    CCSprite *startHLSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Start_HL.png"];
    _startItem = [CCMenuItemSprite itemFromNormalSprite:startSprite selectedSprite:startHLSprite target:self selector:@selector(startBtnPressed)];
    _startItem.anchorPoint = ccp(0.5, 0.5);
    
    //声音开启关闭
    CCSprite *soundOnSprite = [CCSprite spriteWithSpriteFrameName:@"Button_MusicOn.png"];
    CCSprite *soundOnHLSprite = [CCSprite spriteWithSpriteFrameName:@"Button_MusicOn_HL.png"];
    CCMenuItem *soundOnItem = [CCMenuItemSprite itemFromNormalSprite:soundOnSprite selectedSprite:soundOnHLSprite];
    
    CCSprite *soundOffSprite = [CCSprite spriteWithSpriteFrameName:@"Button_MusicOff.png"];
    CCSprite *soundOffHLSprite = [CCSprite spriteWithSpriteFrameName:@"Button_MusicOff_HL.png"];
    CCMenuItem *soundOffItem = [CCMenuItemSprite itemFromNormalSprite:soundOffSprite selectedSprite:soundOffHLSprite];
    
    _soundToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundOn) items:soundOnItem, soundOffItem, nil];
    _soundToggle.anchorPoint = ccp(0.5, 0.5);
    
    if ([ZZPublic isEnabledSoundEffect]) {
        [_soundToggle setSelectedIndex:0];
        CCLOG(@"开启音频");
    } else {
        [_soundToggle setSelectedIndex:1];
        CCLOG(@"关闭音频");
    }
    
    //评价
    CCSprite *rateSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Rate.png"];
    CCSprite *rateHLSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Rate_HL.png"];
    _rateItem = [CCMenuItemSprite itemFromNormalSprite:rateSprite selectedSprite:rateHLSprite target:self selector:@selector(rateThisApp)];
    _rateItem.anchorPoint = ccp(0.5, 0.5);
    
    //去广告
    CCSprite *adSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Ad.png"];
    CCSprite *adHLSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Ad_HL.png"];
    _adItem = [CCMenuItemSprite itemFromNormalSprite:adSprite selectedSprite:adHLSprite target:self selector:@selector(removeAd)];
    _adItem.anchorPoint = ccp(0.5, 0.5);
    
    //信息
    CCSprite *infoSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Info.png"];
    CCSprite *infoHLSprite = [CCSprite spriteWithSpriteFrameName:@"Button_Info_HL.png"];
    _infoItem = [CCMenuItemSprite itemFromNormalSprite:infoSprite selectedSprite:infoHLSprite target:self selector:@selector(showInfo)];
    _infoItem.anchorPoint = ccp(0.5, 0.5);
    [_infoItem setVisible:NO];
    
    _menu = [CCMenu menuWithItems:_startItem, _soundToggle, _rateItem, _adItem, _infoItem, nil];
    [self addChild:_menu z:ORDER_START_LAYER];
    _menu.position = ccp(0, 0);
    
    _startItem.position = _SPSet.start;
    _soundToggle.position = _SPSet.soundOnOff;
    _rateItem.position = _SPSet.rate;
    _adItem.position = _SPSet.ad;
    _infoItem.position = _SPSet.info;
}

- (void)initalPostion {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    if ([ZZPublic isiPad]) {
        _SPSet.start = ccp(winSize.width / 2, 200);
        
        _SPSet.soundOnOff = ccp(70, 50);
        _SPSet.rate = ccp(190, 50);
        _SPSet.ad = ccp(310, 50);
        
        _SPSet.info = ccp(720, 50);
        
        _SPSet.cat = ccp(winSize.width, 0);
        _SPSet.logo = ccp(winSize.width / 2, winSize.height);
        
        _SPSet.logoHide = ccp(_SPSet.logo.x, winSize.height + 300);
        _SPSet.soundOnOffHide = ccp(_SPSet.soundOnOff.x, -60);
        _SPSet.rateHide = ccp(_SPSet.rate.x, -60);
        _SPSet.adHide = ccp(_SPSet.ad.x, -60);
        _SPSet.infoHide = ccp(_SPSet.info.x, -60);
        
    } else if ([ZZPublic isiPhone5]) {
        _SPSet.start = ccp(winSize.width / 2, 120);
        
        _SPSet.soundOnOff = ccp(35, 20);
        _SPSet.rate = ccp(95, 20);
        _SPSet.ad = ccp(155, 20);
        
        _SPSet.info = ccp(295, 20);
        
        _SPSet.cat = ccp(winSize.width, 8);
        _SPSet.logo = ccp(winSize.width / 2, winSize.height);
        
        _SPSet.logoHide = ccp(_SPSet.logo.x, winSize.height + 100);
        _SPSet.soundOnOffHide = ccp(_SPSet.soundOnOff.x, -20);
        _SPSet.rateHide = ccp(_SPSet.rate.x, -20);
        _SPSet.adHide = ccp(_SPSet.ad.x, -20);
        _SPSet.infoHide = ccp(_SPSet.info.x, -20);
        
    } else {
        _SPSet.start = ccp(winSize.width / 2, 110);
        
        _SPSet.soundOnOff = ccp(35, 20);
        _SPSet.rate = ccp(95, 20);
        _SPSet.ad = ccp(155, 20);
        
        _SPSet.info = ccp(295, 20);
        
        _SPSet.cat = ccp(winSize.width, 8);
        _SPSet.logo = ccp(winSize.width / 2, winSize.height);
        
        _SPSet.logoHide = ccp(_SPSet.logo.x, winSize.height + 100);
        _SPSet.soundOnOffHide = ccp(_SPSet.soundOnOff.x, -20);
        _SPSet.rateHide = ccp(_SPSet.rate.x, -20);
        _SPSet.adHide = ccp(_SPSet.ad.x, -20);
        _SPSet.infoHide = ccp(_SPSet.info.x, -20);
    }
}

- (void)registerWithTouchDispatcher {
    //touch is enabled
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN swallowsTouches:YES];
}

+(CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

#pragma mark-
#pragma mark Button Pressed

- (void)startBtnPressed {
    
    //播放音效
    [ZZPublic playEffectWithType:EffectStart];
    
    CCRotateTo *roateCat = [CCRotateTo actionWithDuration:0.5 angle:90];
    [_catSprite runAction:roateCat];
    
    CCMoveTo *moveLogo = [CCMoveTo actionWithDuration:0.5 position:_SPSet.logoHide];
    [_logoSprite runAction:moveLogo];
    
    CCMoveTo *moveSound = [CCMoveTo actionWithDuration:0.2 position:_SPSet.soundOnOffHide];
    [_soundToggle runAction:moveSound];
    
    CCMoveTo *moveRate = [CCMoveTo actionWithDuration:0.3 position:_SPSet.rateHide];
    [_rateItem runAction:moveRate];
    
    CCMoveTo *moveAd = [CCMoveTo actionWithDuration:0.4 position:_SPSet.adHide];
    [_adItem runAction:moveAd];
    
    CCMoveTo *moveInfo = [CCMoveTo actionWithDuration:0.5 position:_SPSet.infoHide];
    [_infoItem runAction:moveInfo];
    
    [_startItem runAction:[CCHide action]];
    
    _menu.isTouchEnabled = NO;
    
    [[HelloWorldLayer sharedHelloScene] setIsTouchedLayer:YES];
    [[HelloWorldLayer sharedHelloScene] setAdIsHidden:NO];
}

- (void)showStartLayer {
    CCRotateTo *roateCat = [CCRotateTo actionWithDuration:0.5 angle:0];
    [_catSprite runAction:roateCat];
    
    CCMoveTo *moveLogo = [CCMoveTo actionWithDuration:0.5 position:_SPSet.logo];
    [_logoSprite runAction:moveLogo];
    
    CCMoveTo *moveSound = [CCMoveTo actionWithDuration:0.2 position:_SPSet.soundOnOff];
    [_soundToggle runAction:moveSound];
    
    CCMoveTo *moveRate = [CCMoveTo actionWithDuration:0.3 position:_SPSet.rate];
    [_rateItem runAction:moveRate];
    
    CCMoveTo *moveAd = [CCMoveTo actionWithDuration:0.4 position:_SPSet.ad];
    [_adItem runAction:moveAd];
    
    CCMoveTo *moveInfo = [CCMoveTo actionWithDuration:0.5 position:_SPSet.info];
    [_infoItem runAction:moveInfo];
    
    [_startItem runAction:[CCShow action]];
    
    _menu.isTouchEnabled = YES;
    
    [[HelloWorldLayer sharedHelloScene] setIsTouchedLayer:NO];
    [[HelloWorldLayer sharedHelloScene] setAdIsHidden:YES];

}

- (void)soundOn {
    if ([ZZPublic isEnabledSoundEffect]) {
        [ZZPublic setIsEnabledSoundEffect:NO];
        [ZZPublic unloadSoundEffect];
    } else {
        [ZZPublic setIsEnabledSoundEffect:YES];
        [ZZPublic preloadSoundEffect];
        
        [ZZPublic playEffectWithType:EffectStart];
    }
    
}

#define URL_RATE_IOS7 @"itms-apps://itunes.apple.com/app/id"
#define URL_RATE_IOS6 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
- (void)rateThisApp {
    
    [ZZPublic playEffectWithType:EffectStart];
    
//    [ZZPublic playBtnPressedEffect];
    
    NSString *rateMe = [NSString stringWithFormat:@"%@%@", (IOS_NEWER_OR_EQUAL_TO_7 ? URL_RATE_IOS7 : URL_RATE_IOS6), APP_ID];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateMe]];
    
}

- (void)removeAd {
    
    [ZZPublic playEffectWithType:EffectStart];
    
//    [ZZPublic playBtnPressedEffect];
    
    [self buyWhichProduct:IAP_PRODUCT_ID];
    
    [self setIndicatorShow];
    
}

- (void)showInfo {
    [ZZPublic playEffectWithType:EffectStart];
    
}

#pragma mark - IAP

- (void)buyWhichProduct:(NSString *)PID {
    
    if ([SKPaymentQueue canMakePayments]) {
        
        //请求产品信息
        NSArray *productArray = [[NSArray alloc] initWithObjects:PID, nil];
        
        NSSet *productSet = [NSSet setWithArray:productArray];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
        request.delegate = self;
        [request start];
        [productArray release];
        
        //        NSLog(@"允许程序内付费购买");
    } else {
        
        //        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"STORE_ALERT_TITLE", nil) message:NSLocalizedString(@"STORE_ALERT_MSG", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"STORE_ALERT_CLOSE", nil) otherButtonTitles:nil];
        
        [alerView show];
        [alerView release];
        
    }
}

//记录交易
-(void)recordTransaction:(NSString *)productName{
    //    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)productName{
    //        NSLog(@"购买成功，给100金币");
    
    CCLOG(@"成功购买");
    
    [ZZPublic setIsHiddenAd:YES];
    [[HelloWorldLayer sharedHelloScene] setAdIsHidden:YES];
    
    NSString *msg = @"您已成功除去广告，感谢支持！";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买成功" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    
    
    
}

- (void)transactionCompleted:(SKPaymentTransaction *)transaction {
    
    //    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)transactionFailed:(SKPaymentTransaction *)transaction {
    //    NSLog(@"------失败--------");
    [self setIndicatorOff];
    if (transaction.error.code != SKErrorPaymentCancelled){
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)transactionRestored:(SKPaymentTransaction *)transaction {
    //    NSLog(@"交易恢复处理");
    
    NSString *PID = transaction.payment.productIdentifier;
    
    if ([PID length] > 0) {
        NSArray *temp = [PID componentsSeparatedByString:@"."];
        NSString *productName = [temp lastObject];
        
        if ([productName length] > 0) {
            [self provideContent:productName];
        }
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    //    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self transactionCompleted:transaction];
                
                [self setIndicatorOff];
                
                //                NSLog(@"-----交易完成 --------");
                //                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"STORE_ALERT_CON", nil) message:NSLocalizedString(@"STORE_ALERT_CON_MSG", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"STORE_ALERT_CON_OK", nil) otherButtonTitles:nil];
                //
                //                [alerView show];
                //                [alerView release];
                
                break;
            case SKPaymentTransactionStatePurchasing:
                //                NSLog(@"-----商品添加进列表 --------");
                break;
                
            case SKPaymentTransactionStateFailed:
                [self transactionFailed:transaction];
                //                NSLog(@"-----交易失败--------");
                
                [self setIndicatorOff];
                
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"STORE_ALERT_FAIL_MSG", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"STORE_ALERT_CLOSE", nil) otherButtonTitles:nil];
                
                [alerView2 show];
                [alerView2 release];
                break;
                
            case SKPaymentTransactionStateRestored:
                //                NSLog(@"-----已经购买过该商品 --------");
                [self transactionRestored:transaction];
                
                [self setIndicatorOff];
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    [self setIndicatorOff];
    //    NSLog(@"restoreCompletedTransactionsFailedWithError");
    
}

//- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
//    NSLog(@"removedTransactions");
//}
//
//- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
//    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");
//}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *myProducts = response.products;
    if ([myProducts count] >= 1) {
        //    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
        //    NSLog(@"产品付费数量: %d", [myProducts count]);
        
        SKPayment *payment = nil;
        for (SKProduct *product in myProducts) {
            //        NSLog(@"product info");
            //        NSLog(@"SKProduct 描述信息%@", [product description]);
            //        NSLog(@"产品标题 %@" , product.localizedTitle);
            //        NSLog(@"产品描述信息: %@" , product.localizedDescription);
            //        NSLog(@"价格: %@" , product.price);
            //        NSLog(@"Product id: %@" , product.productIdentifier);
            payment = [SKPayment paymentWithProduct:product];
        }
        
        //    NSLog(@"---------发送购买请求------------");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [request autorelease];
    } else {
        [self setIndicatorOff];
        
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SORRY", nil) message:NSLocalizedString(@"FAIL_GET_INFO", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"STORE_ALERT_CON_OK", nil) otherButtonTitles:nil];
        
        [alerView show];
        [alerView release];
    }
}

#pragma mark - SKRequestDelegate

//下载失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    [self setIndicatorOff];
    
    //    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"STORE_ALERT_TITLE", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"STORE_ALERT_CLOSE", nil) otherButtonTitles:nil];
    
    [alerView show];
    [alerView release];
}

- (void)requestDidFinish:(SKRequest *)request {
    //    NSLog(@"----------反馈信息结束--------------");
}

- (void)setIndicatorShow {
    
    NSString *str = NSLocalizedString(@"PLEASE_WAIT", @"请稍后...");
    _indicator = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator addSubview:indicatorView];
    [indicatorView startAnimating];
    CGRect rect = indicatorView.frame;
    rect.origin.x += 125;
    rect.origin.y += 50;
    [indicatorView setFrame:rect];
    [indicatorView release];
    [_indicator show];
    [_indicator release];
    
    [self performSelector:@selector(setIndicatorOff) withObject:nil afterDelay:30];
}

- (void)setIndicatorOff {
    if (_indicator) {
        [_indicator dismissWithClickedButtonIndex:0 animated:YES];
        _indicator = nil;
    }
}

@end
