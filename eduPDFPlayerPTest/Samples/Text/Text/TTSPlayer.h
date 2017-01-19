//
//  TTSPlayer.h
//  Text
//
//  Created by 허기수 on 2017. 1. 7..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eduPDFPlayer;

typedef enum : NSUInteger {
    TTSPlayerStateStop,
    TTSPlayerStatePlaying,
    TTSPlayerStatePause
} TTSPlayerState;

@interface TTSPlayer : NSObject

@property(nonatomic, weak) eduPDFPlayer *player;    // eduPDFPlayer
@property(nonatomic, assign) TTSPlayerState state;  // TTS 재생 상태

- (void)play;
- (void)pause;
- (void)next;
- (void)prev;
- (void)stop;
- (void)changedPage:(int)pageNo;    // 페이지가 변경될 때 호출해야 합니다.

@end
