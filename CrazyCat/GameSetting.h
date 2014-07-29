//
//  GameSetting.h
//  CrazyCat
//
//  Created by zhaozilong on 14-7-26.
//
//

#ifndef CrazyCat_GameSetting_h
#define CrazyCat_GameSetting_h

#define INDEX_CIRCLE_START 40
#define NUM_OF_COLUM 9
#define WIDTH_OF_CIRCLE ([ZZPublic isiPad] ? 65.0f : 31.0f)

#define ORDER_START_LAYER 100

#define ADMOB_ID @"ca-app-pub-6172734071837912/2811020984"
#define APP_ID @"903729466"
#define FLURRY_ID @"SCR7PBBK3NCMYC6VWJSZ"
#define IAP_PRODUCT_ID @"IAP.Voocee.CrazyCat.RemoveAd"

#define SHARESDK_APPID @"27a39f2a8220"

#define SHARESDK_APPKEY_SINA @"1136309282"
#define SHARESDK_APPSECRET_SINA @"4690c1f92d4ca95910336252ff12f29d"
#define SHARESDK_REDIRECTURI @"https://itunes.apple.com/app/id903729466"

#define SHARESDK_APPID_WX @"wxe0bae03e1219d7fd"

//tag集合
typedef enum {
    ZZStartLayerTag = 111,
    ZZEndingLayerTag,
    CCNodeMAXTag = INT_MAX,
}CCNodeTag;

#endif
