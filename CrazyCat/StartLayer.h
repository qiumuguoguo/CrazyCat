//
//  StartLayer.h
//  CrazyCat
//
//  Created by zhaozilong on 14-7-27.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import <StoreKit/StoreKit.h>

//所有的位置坐标
typedef struct StartPostion {
    
    CGPoint start;
    
    CGPoint soundOnOff;
    CGPoint soundOnOffHide;
    CGPoint rate;
    CGPoint rateHide;
    CGPoint ad;
    CGPoint adHide;
    
    CGPoint info;
    CGPoint infoHide;
    
    //Logo
    CGPoint cat;
    CGPoint logo;
    CGPoint logoHide;
    
}StartPostionSet;

@interface StartLayer : CCLayer/*<SKPaymentTransactionObserver, SKProductsRequestDelegate, SKRequestDelegate>*/ {
//    StartPostionSet _SPSet;
    
}

@property StartPostionSet SPSet;

- (void)showStartLayer;

@end
