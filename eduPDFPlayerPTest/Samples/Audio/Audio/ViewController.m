//
//  ViewController.m
//  Annotation
//
//  Created by 허기수 on 2016. 12. 29..
//  Copyright © 2016년 Unidocs Inc. All rights reserved.
//

#import "ViewController.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>
#import "TouchInputView.h"

@interface ViewController ()

@property(nonatomic, strong) eduPDFPlayer *player;
@property(weak) IBOutlet UIButton *playButton;
@property(weak) IBOutlet TouchInputView *inputView;

@end

@implementation ViewController
{
    int reserveAutoPlayPageNo;  // 자동 재생 필요한 페이지 예약
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)initPlayer
{
    __weak ViewController *weakSelf = self;
    [self.player setAudioStateChanged:^(int pageNo, EDPlayStateType type) { // 재생중인 오디오 상태 변경시
        NSLog(@"Audio State Changed = %d", pageNo);
        switch (type) {
            case EDPlayStateStop:   // 중지
                break;
            case EDPlayStatePlaying:    // 재생 중
                break;
            case EDPlayStatePause:  // 일시 정지
                break;
            case EDPlayStateFinish: // 재생 완료
                break;
        }
        weakSelf.playButton.selected = [weakSelf.player isAudioPlaying];    // 재생 상태를 버튼에 표시
    }];

    // 기본 정책상으로 오디오 재생위치와 현재 페이지가 일치 하지 않을 수 있습니다.
    // 만일 일치하게 정책을 정하고 구현하려면 아래와 같이 구현이 필요합니다.
    [self.player setChangedPage:^(int pageNo) {
        [weakSelf autoPlay:pageNo];
    }];
    
    [self.player setAudioPlayFinished:^(int pageNo) // 오디오 재생이 끝나면
     {
         if (weakSelf.player.enableAudioesAutoPlay) {   // 자동 재생중이면
             if (pageNo < [weakSelf.player pageCount]) {    // 마지막 페이지가 아니라면
                 [weakSelf.player nextPage:^(EDPageMoveFinishedType finished) {  // 다음 페이지로 이동 합니다.
                 }];
             }
         }
         NSLog(@"Audio play finished pageNo = %d", pageNo);
     }];

    [self.player setLoadedPage:^(int pageNo) {
        if(reserveAutoPlayPageNo == pageNo)
        {
            [weakSelf autoPlay:pageNo];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.player = [eduPDFPlayer new];
    self.inputView.player = self.player;
    [self initPlayer];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EBS_귀가트이는영어_Sample_7-12p_160415" ofType:@"pdf"];
    EDPageConfig *config = [EDPageConfig new];  //양면 보기 설정
    config.displayPageCount = 1;
    config.blankPageCount = 0;
    config.documentPageLayout = NO;
    config.scrollDisable = YES; // 뷰어 스크롤 금지
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    docProvider.config = config;
    
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [self.player viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

// 자동 재생
- (void)autoPlay:(int)pageNo
{
    if (self.player.enableAudioesAutoPlay) {    // 오디오 자동 재생 모드일 때 오디오 재생을 이동한 페이지에 동기화
        if (![self.player isLoadedPage:pageNo]) {
            if (pageNo == [self.player currentPageNo]) {    // 해당 페이지와 현재 페이지가 같으면
                reserveAutoPlayPageNo = pageNo;
            }
            return;
        }
        CGFloat delay = 3.0;    // 사용자 입력을 위해 3초 정도 지연시간을 가지고
        if ([self.player hasAudio:pageNo]) {    // 현재 페이지가 오디오를 가지고 있다면
            delay = 1.0;    // 지연시간을 줄이고
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.player.enableAudioesAutoPlay) {    // 자동 재생 모드 이면
                if (pageNo == [self.player currentPageNo]) {    // 해당 페이지와 현재 페이지가 같으면
                    if ([self.player isAudioPlaying] == NO) {   // 그리고, 오디오가 재생중이 아니라면
                        [self.player firstAudioPlay:pageNo completion:^(int pageNo, BOOL secuess) { // 해당 페이지 첫번째 오디오를 재생합니다.
                            if (secuess == NO) {    // 만약 재생을 할 수 없다면
                                [self.player nextPage:^(EDPageMoveFinishedType finished) {  // 다음 페이지로 이동 합니다.
                                }];
                            }
                        }];
                    }
                }
            }
        });
    }
}

#pragma mark - Action

- (IBAction)autoPlayEnable:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.player.enableAudioesAutoPlay = sender.selected;    // 자동 재생 할지 여부 설정
}

- (IBAction)firstAudioPlay:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {  // 일시 중지 상태
        __weak eduPDFPlayer *weakPlayer = self.player;
        if (self.player.audioPlayState == EDPlayStatePause) { // 현재 재생 오디오가 일시 중지 상태 이면
            [self.player audioResume];  // 다시 재생을 재개 합니다.
        } else {
            [self.player firstAudioPlay:[self.player currentPageNo] completion:^(int pageNo, BOOL secuess) {    // 지금 보이는 페이지에서 첫 오디오 부터 재생합니다.
                sender.selected = [weakPlayer isAudioPlaying];  // 재생 상태 표시
                NSLog(@"Audio started pageNo = %d", pageNo);
            }];
        }
        [self.player setAudioPlayFinished:^(int pageNo) {   // 재생이 완료될 때
            sender.selected = [weakPlayer isAudioPlaying];  // 재생 상태 표시
            NSLog(@"Audio play finished pageNo = %d", pageNo);
        }];
    } else {    // 재생 중이면
        if (self.player.audioPlayState == EDPlayStatePlaying) { // 재생 상태 라면
            [self.player audioPause];   // 일시 중지 합니다.
        }
    }
}

- (IBAction)audioList:(id)sender    // 오디오 목록 가져오기
{
    for (int pageNo = 1; pageNo<=[self.player pageCount]; ++pageNo) {
        NSArray<EDAnnotation *> *annots = [self.player getAnnotations:pageNo];
        for (EDAnnotation *annot in annots) {
            NSArray<EDLink *> *links = [annot getAllLinks];
            for (EDLink *link in links) {
                if ([link isAudio]) {
                    NSLog(@"Audio Link pageNo = %d, name = %@", [annot pageNo], link.destURI);
                }
            }
        }
    }
}

- (IBAction)prevPage:(id)sender
{
    [self.player audioStop];    // 이전에 재생중이던 오디오는 중지 합니다.
    [self.player prevPage:^(EDPageMoveFinishedType finished) {
        
    }];
}

- (IBAction)nextPage:(id)sender
{
    [self.player audioStop];    // 이전에 재생중이던 오디오는 중지 합니다.
    [self.player nextPage:^(EDPageMoveFinishedType finished) {
        
    }];
}

@end
