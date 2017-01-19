//
//  ViewController.m
//  Text
//
//  Created by puttana on 2017. 1. 5..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import "ViewController.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>
#import "TTSPlayer.h"

@interface ViewController ()

@property(nonatomic, strong) eduPDFPlayer *player;
@property(nonatomic, strong) EDTouchCoordination *touchCoord;   // 마지막 터치 탭 정보

@property(nonatomic, strong) TTSPlayer *ttsPlayer;  // TTS 재생기
@property(nonatomic, weak) IBOutlet UIButton *playButton;   // TTS 재생 버튼

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 컨텍스 메뉴
- (void)showMenu:(EDTouchCoordination *)touchCoord targetRect:(CGRect)targetRect inView:(UIView *)inView
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"복사" action:@selector(copyText:)], [[UIMenuItem alloc] initWithTitle:@"강조" action:@selector(highlightAnnot:)]]];
    if (inView) {
        [menuController setTargetRect:targetRect inView:inView];
    }
    [menuController setMenuVisible:YES animated:YES];
}

- (void)initPlayer
{
    __weak ViewController *weakSelf = self; // 메모리 누수나지 않게 weak reference
    [self.player setTouchOneTap:^(EDTouchCoordination *touchCoord) {    // 페이지 원탭후 호출
        switch (touchCoord.type) {
            case EDTouchPage:
                if (!weakSelf.player.annotationInserting) {   // 주석 입력 중이 아니면
                    
                }
                break;
            case EDTouchTextSelection:
                weakSelf.touchCoord = touchCoord;
                [weakSelf showMenu:touchCoord targetRect:touchCoord.text.frame inView:touchCoord.objectView.superview];    // 텍스트 선택시 메뉴를 뛰웁니다.
                break;
            default:
                break;
        }
        NSLog(@"touchOneTap point = %@ frame = %@", [NSValue valueWithCGPoint:touchCoord.pointDisplay], [NSValue valueWithCGRect:touchCoord.frameDisplay]);
    }];

    self.ttsPlayer = [TTSPlayer new];   // TTS 재생기를 생성합니다.
    self.ttsPlayer.player = self.player;
    
    [self.player setChangedPage:^(int pageNo) { // 페이지가 변경됬을 때 단락 갱신하기 위해 TTS 재생기에 changedPage를 호출하였습니다.
        [weakSelf.ttsPlayer changedPage:pageNo];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.player = [eduPDFPlayer new];
    [self initPlayer];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"adobe_supplement_iso32000" ofType:@"pdf"];
    
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    EDPageConfig *config = [EDPageConfig new];
    // 텍스트 선택 영역 표시 색상을 설정할 수 있습니다. 설정하지 않으면 기본값을 적용합니다.
    config.textSelectionCaretColor = [UIColor colorWithRed:0.1 green:0.2 blue:1.0 alpha:1.0];
    config.textSelectionBodyColor = [UIColor colorWithRed:0.1 green:0.2 blue:1.0 alpha:0.1];
    docProvider.config = config;
    
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [self.player viewWillTransitionToSize:size withTransitionCoordinator:coordinator];  // 회전시 반드시 호출해야 합니다.
}

#pragma mark - UIMenuController

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)selector withSender:(id)sender {
    if ([self.touchCoord.text.contents length]) {
        if (selector == @selector(copyText:)) {
            return YES;
        }
    }
    if (self.touchCoord.annotMakerParam) {
        if (selector == @selector(highlightAnnot:)) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)copyText:(id)sender  // 텍스트 복사
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard containsPasteboardTypes: [NSArray arrayWithObject:@"public.utf8-plain-text"]];
    pasteboard.string = self.touchCoord.text.contents;

    [self showMenu:self.touchCoord targetRect:CGRectZero inView:nil]; // 메뉴를 다시 뛰웁니다.
}

- (IBAction)highlightAnnot:(id)sender // 강조 주석 생성
{
    self.touchCoord.annotMakerParam.type = @"Highlight";
    [self.player markupAnnotationInsert:self.touchCoord.annotMakerParam];
    [self.player clearSelection];   // 텍스트 선택 영역을 제거
}


#pragma mark - Action

- (IBAction)search:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {  // 텍스트 검색
        EDTextSelection *searchText = [EDTextSelection new];
        searchText.search = @"ISO";
        searchText.pageNo = [self.player currentPageNo];    // 현재 페이지에서 부터 검색 시작
        searchText.color = [UIColor colorWithRed:0.3 green:0.7 blue:1.0 alpha:0.2]; // 강조 표시 색상 설정
        [self.player searchText:searchText searching:^(NSArray<EDTextSelection *> * _Nullable searchedTextSelections, int pageNo) {
            NSLog(@"-----------------------------------------");
            NSLog(@"searched text selections = %lu, pageNo = %d", (unsigned long)[searchedTextSelections count], pageNo);
            for(EDTextSelection *sel in searchedTextSelections)
            {
                NSLog(@"searched text = %@", sel.contents);
            }
        } completion:^(BOOL cancel) {
            NSLog(@"searchText completion cancel = %d", cancel);
        }];
    } else {    // 텍스트 검색 중지
        [self.player stopSearchText];   // 중지하면 검색한 텍스트 강조 표시는 제거
    }
}

#pragma mark - TTS Action

- (IBAction)prevTTS:(id)sender
{
    [self.ttsPlayer prev];
    self.playButton.selected = self.ttsPlayer.state == TTSPlayerStatePlaying; // 재생중일 때만 'Pause' 타이틀을 표시 합니다.
}

- (IBAction)nextTTS:(id)sender
{
    [self.ttsPlayer next];
    self.playButton.selected = self.ttsPlayer.state == TTSPlayerStatePlaying;
}

- (IBAction)stopTTS:(id)sender
{
    [self.ttsPlayer stop];
    self.playButton.selected = self.ttsPlayer.state == TTSPlayerStatePlaying;
}

- (IBAction)playTTS:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.ttsPlayer play];
    } else {
        [self.ttsPlayer pause];
    }
    self.playButton.selected = self.ttsPlayer.state == TTSPlayerStatePlaying;
}

@end
