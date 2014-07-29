//
//  EndingLayer.h
//  CrazyCat
//
//  Created by zhaozilong on 14-7-25.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//typedef enum {
//    ShareTypeSOS,
//    ShareTypeShare,
//    ShareTypeNONE,
//    
//}ShareBoradShareType;

@interface EndingLayer : CCLayer {
    
}

//- (id)initWithShareType:(ShareBoradShareType)SBSType;
- (id)initWithSteps:(int)num success:(BOOL)isSuccess;

@end
