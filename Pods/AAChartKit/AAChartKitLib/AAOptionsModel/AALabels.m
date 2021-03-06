//
//  AALabels.m
//  AAChartKit
//
//  Created by An An on 17/3/1.
//  Copyright Â© 2017å¹´ An An. All rights reserved.
//*************** ...... SOURCE CODE ...... ***************
//***...................................................***
//*** https://github.com/AAChartModel/AAChartKit        ***
//*** https://github.com/AAChartModel/AAChartKit-Swift  ***
//***...................................................***
//*************** ...... SOURCE CODE ...... ***************

/*
 
 * -------------------------------------------------------------------------------
 *
 * ð ð ð ð  âââ   WARM TIPS!!!   âââ ð ð ð ð
 *
 * Please contact me on GitHub,if there are any problems encountered in use.
 * GitHub Issues : https://github.com/AAChartModel/AAChartKit/issues
 * -------------------------------------------------------------------------------
 * And if you want to contribute for this project, please contact me as well
 * GitHub        : https://github.com/AAChartModel
 * StackOverflow : https://stackoverflow.com/users/12302132/codeforu
 * JianShu       : https://www.jianshu.com/u/f1e6753d4254
 * SegmentFault  : https://segmentfault.com/u/huanghunbieguan
 *
 * -------------------------------------------------------------------------------
 
 */

#import "AALabels.h"
#import "NSString+toPureJSString.h"

@implementation AALabels

- (instancetype)init {
    self = [super init];
    if (self) {
        _enabled = true;
    }
    return self;
}

AAPropSetFuncImplementation(AALabels, NSString *, align)//è½´æ ç­¾çå¯¹é½æ¹å¼ï¼å¯ç¨çå¼æ "left"ã"center" å "right"ãé»è®¤å¼æ¯æ ¹æ®åæ è½´çä½ç½®ï¼å¨å¾è¡¨ä¸­çä½ç½®ï¼å³æ ç­¾çæè½¬è§åº¦è¿è¡æºè½å¤æ­çã é»è®¤æ¯ï¼center.
AAPropSetFuncImplementation(AALabels, id        , autoRotation)//åªéå¯¹æ°´å¹³è½´ææï¼åè®¸å¨é²æ­¢è½´æ ç­¾éå æ¶èªå¨æè½¬è½´æ ç­¾çè§åº¦ãå½ç©ºé´è¶³å¤æ¶ï¼è½´æ ç­¾ä¸ä¼è¢«æè½¬ãå½å¾è¡¨åå°æ¶ï¼ä¸»è¦æ¯å®½åº¦åå°ï¼ ï¼è½´æ ç­¾å¼å§æè½¬å¯¹åºçè§åº¦ï¼ç¶åä¼ä¾æ¬¡å é¤é´éçè½´æ ç­¾å¹¶å°è¯æè½¬æ°ç»ä¸­çè§åº¦ãå¯ä»¥éè¿å°æ­¤åæ°è®¾ç½®ä¸º false æ¥å³é­è½´æ ç­¾æè½¬ï¼è¿å°å¯¼è´æ ç­¾èªå¨æ¢è¡ï¼ã é»è®¤æ¯ï¼[-45].
AAPropSetFuncImplementation(AALabels, NSNumber *, autoRotationLimit)//å½æ¯ä¸ªåç±»çå®½åº¦æ¯è¯¥åæ°çå¼å¤§å¾å¤ï¼åç´ ï¼æ¶ï¼è½´æ ç­¾å°ä¸ä¼è¢«èªå¨æè½¬ï¼èæ¯ä»¥æ¢è¡çå½¢å¼å±ç¤ºè½´æ ç­¾ã å½è½´æ ç­¾åå«å¤ä¸ªç­è¯æ¶æ¢è¡å±ç¤ºè½´æ ç­¾å¯ä»¥ä½¿å¾è½´æ ç­¾æè¶³å¤çç©ºé´ï¼æä»¥è®¾ç½®åççèªå¨æè½¬ä¸éæ¯éå¸¸ææä¹çã é»è®¤æ¯ï¼80.
AAPropSetFuncImplementation(AALabels, NSNumber *, distance)//åªéå¯¹æå°å¾ææï¼å®ä¹å¨æ ç­¾ä¸ç»å¾åºè¾¹ç¼çè·ç¦»ã é»è®¤æ¯ï¼15.
AAPropSetFuncImplementation(AALabels, BOOL      , enabled)//æ¯å¦æ¾ç¤ºåæ è½´æ ç­¾ é»è®¤æ¯ï¼true.
AAPropSetFuncImplementation(AALabels, NSString *, format)//åæ è½´æ ¼å¼åå­ç¬¦ä¸²ã é»è®¤æ¯ï¼{value}.
//AAPropSetFuncImplementation(AALabels, NSString *, formatter)//åæ è½´æ ¼å¼åå­ç¬¦ä¸²ã é»è®¤æ¯ï¼{value}.
AAPropSetFuncImplementation(AALabels, NSNumber *, padding)//è½´æ ç­¾çåé´è·ï¼ä½ç¨æ¯ä¿è¯è½´æ ç­¾ä¹é´æç©ºéã é»è®¤æ¯ï¼5.
AAPropSetFuncImplementation(AALabels, NSNumber *, rotation)//è½´æ ç­¾çæè½¬è§åº¦ é»è®¤æ¯ï¼0.
AAPropSetFuncImplementation(AALabels, NSNumber *, staggerLines)//åªéå¯¹æ°´å¹³è½´ææï¼å®ä¹è½´æ ç­¾æ¾ç¤ºè¡æ°ã
AAPropSetFuncImplementation(AALabels, NSNumber *, step)//æ¾ç¤º n çåæ°æ ç­¾ï¼ä¾å¦è®¾ç½®ä¸º 2 åè¡¨ç¤ºæ ç­¾é´éä¸ä¸ªè½´æ ç­¾æ¾ç¤ºãé»è®¤æåµä¸ï¼ä¸ºäºé¿åè½´æ ç­¾è¢«è¦çï¼è¯¥åæ°ä¼æ ¹æ®æåµèªå¨è®¡ç®ãå¯ä»¥éè¿è®¾ç½®æ­¤åæ°ä¸º 1 æ¥é»æ­¢èªå¨è®¡ç®ã
AAPropSetFuncImplementation(AALabels, AAStyle  *, style)//è½´æ ç­¾ç CSS æ ·å¼
AAPropSetFuncImplementation(AALabels, NSNumber *, x)//ç¸å¯¹äºåæ è½´å»åº¦çº¿çæ°´å¹³åç§»ã é»è®¤æ¯ï¼0.
AAPropSetFuncImplementation(AALabels, NSNumber *, y)//ç¸å¯¹äºåæ è½´å»åº¦çº¿çåç´å¹³åç§»ã é»è®¤æ¯ï¼null.
AAPropSetFuncImplementation(AALabels, BOOL      , useHTML)//HTMLæ¸²æ

AAJSFuncTypePropSetFuncImplementation(AALabels, NSString *, formatter)//åæ è½´æ ¼å¼åå­ç¬¦ä¸²ã é»è®¤æ¯ï¼{value}.

- (void)setFormatter:(NSString *)formatter {
    _formatter = [formatter aa_toPureJSString];
}

@end
