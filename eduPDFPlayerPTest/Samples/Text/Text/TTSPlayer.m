//
//  TTSPlayer.m
//  Text
//
//  Created by 허기수 on 2017. 1. 7..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import "TTSPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <eduPDFPlayerS/eduPDFPlayer.h>

@interface TTSPlayer()<AVSpeechSynthesizerDelegate>

@property(nonatomic, strong) NSArray *textParagraph;
@property(nonatomic, assign) int minPageNo;
@property(nonatomic, assign) int maxPageNo;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

@end

@implementation TTSPlayer

- (EDTextSelection *)currentSelection   // 현재 표시중인 문장
{
    if (self.index < [self.textParagraph count]) {
        return self.textParagraph[self.index];
    }
    return nil;
}

- (void)hideHighlight   // 현재 문장 강조 표시 제거
{
    [self.player clearHighlight];
}

- (void)showHighlight   // 현재 문장 강조 표시
{
    EDTextSelection *sel = [self currentSelection];
    if (sel) {
        sel.color = [UIColor colorWithRed:0.8 green:0.9 blue:0.1 alpha:0.2];    // 강조 색상을 지정할 수 있습니다.
        [self.player showHighlight:sel];
    }
}

- (void)update
{
    int npno = [self.player currentPageNo];;
    if (npno != self.minPageNo) {   // 페이지가 변경 되었다면 다시 페이지 단락을 가져와야 합니다.
        [self hideHighlight];
        self.minPageNo = npno;
        self.maxPageNo = [self.player currentMaxPageNo];    // 양면보기 이상일 때는 currentPageNo와 currentMaxPageNo가 틀립니다.
        NSMutableArray *tps = [NSMutableArray new];
        for (int pageNo=self.minPageNo; pageNo<=self.maxPageNo; ++pageNo) { // 화면에 보이는 페이지들에서 모든 단락을 가져와야 합니다.
            [tps addObjectsFromArray:[self.player getTextParagraph:pageNo]];
        }
        self.textParagraph = [NSArray arrayWithArray:tps]; // 단락 설정
        self.index = 0;
    }
}

#pragma mark - Public API

- (void)play
{
    if (self.speechSynthesizer == nil) {
        self.speechSynthesizer = [[AVSpeechSynthesizer alloc]init];
        self.speechSynthesizer.delegate = self;
    }
    if (self.state == TTSPlayerStatePause) {    // 일시 중지 이면 재생을 재개 합니다.
        [self.speechSynthesizer continueSpeaking];
        return;
    }
    [self update];  // 단락 업데이트
    [self showHighlight];   // 강조 표시
    self.state = TTSPlayerStatePlaying;
    EDTextSelection *sel = [self currentSelection]; // 현재 문장을 가져와 TTS에 설정합니다.
    if (sel == nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self next];
        });
    } else {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:sel.contents];
        [self.speechSynthesizer speakUtterance:utterance];
        
    }
}

- (void)pause
{
    self.state = TTSPlayerStatePause;
    [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (void)next
{
    [self hideHighlight];
    if (self.state == TTSPlayerStatePause) {    // 일시중지 중에 문장 커서를 이동시키면 중지합니다.
        [self stop];
    }
    self.index = self.index+1;
    if ([self.textParagraph count] <= self.index) { // 더 이상 다음 문장이 없다면 다음 페이지로 이동합니다.
        [self.player nextPage:^(EDPageMoveFinishedType finished) {
            if (finished != EDPageMove_Success) {   // 더 이상 다음 페이지가 없으면 중지 합니다.
                if (finished == EDPageMove_Ing) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self next];
                    });
                } else {
                    [self stop];
                }
            } else {    // 다음 페이지로 이동하면 현재 문장 강조 표시를 합니다.
                [self showHighlight];
            }
        }];
    } else {
        if (self.state == TTSPlayerStatePlaying) {  // 재생중이면 TTS재생을 중지하고 다시 재생합니다.
            [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            [self play];
        } else {    // 재생중이 아니면 문장 커서만 이동 합니다.
            [self update];
            [self showHighlight];
        }
    }
}

- (void)prev    // next와 동일
{
    [self hideHighlight];
    if (self.state == TTSPlayerStatePause) {
        [self stop];
    }
    if (0 == self.index) {
        [self.player prevPage:^(EDPageMoveFinishedType finished) {
            if (finished != EDPageMove_Success) {
                if (finished == EDPageMove_Ing) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self prev];
                    });
                } else {
                    [self stop];
                }
            } else {
                [self showHighlight];
            }
        }];
    } else {
        self.index = self.index-1;
        if (self.state == TTSPlayerStatePlaying) {
            [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            [self play];
        } else {
            [self update];
            [self showHighlight];
        }
    }
}

- (void)stop
{
    [self hideHighlight];
    self.state = TTSPlayerStateStop;
    [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    self.speechSynthesizer = nil;
    self.index = 0;
}

- (void)changedPage:(int)pageNo
{
    TTSPlayerState oldState = self.state;
    [self stop];
    self.state = oldState;
    if (self.state == TTSPlayerStatePlaying) {  // 페이지 변경 됬을 때 재생 중 이면 현재 문장을 재생합니다.
        // next와 계속 서로 호출할 수 도 있기 때문에 지연 처리를 합니다.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self play];
        });
    } else {    // 재생중이 아니면 단락만 업데이트 합니다.
        [self update];
    }
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    if (self.state == TTSPlayerStatePlaying) {  // 재생중일때 TTS재생이 완료 되었다면 다음 문장으로 커서를 이동 합니다.
        if(utterance.speechString == [self currentSelection].contents)
            [self next];
    }
}

@end
