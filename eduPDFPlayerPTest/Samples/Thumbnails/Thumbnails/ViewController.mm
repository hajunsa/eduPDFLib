//
//  ViewController.m
//  Thumbnails
//
//  Created by puttana on 2017. 1. 9..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import "ViewController.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>
#import "ReaderMainPagebar.h"
#import "CustomOutlines.h"

@interface ViewController ()<ReaderMainPagebarDelegate>

@property(nonatomic, strong) eduPDFPlayer *player;
@property(nonatomic, weak) IBOutlet UIView *thumbnailsBarContainView;
@property(nonatomic, weak) ReaderMainPagebar *mainPagebar;
@property(nonatomic, weak) IBOutlet UIButton *bookmarkButton;

@end

@implementation ViewController

- (void)initPlayer
{
    // 페이지 네비게이션바를 오픈 소스(ReaderMainPagebar)를 이용하였습니다.
    CGRect f = self.thumbnailsBarContainView.bounds;
    ReaderMainPagebar *mainPagebar = [[ReaderMainPagebar alloc] initWithFrame:f document:self.player];
    mainPagebar.delegate = self;
    self.mainPagebar = mainPagebar;
    [self.thumbnailsBarContainView addSubview:mainPagebar];

    __weak ViewController *weakSelf = self; // 메모리 누수나지 않게 weak reference
    [self.player setTouchOneTap:^(EDTouchCoordination *touchCoord) {    // 페이지 원탭후 호출
        switch (touchCoord.type) {
            case EDTouchPage:
                break;
            default:
                break;
        }
        NSLog(@"touchOneTap point = %@ frame = %@", [NSValue valueWithCGPoint:touchCoord.pointDisplay], [NSValue valueWithCGRect:touchCoord.frameDisplay]);
    }];
    
    [self.player setChangedPage:^(int pageNo) {
        [weakSelf.mainPagebar updatePagebar];   // 페이지 변경시 페이지 네비게이션 바를 갱신합니다.
        [weakSelf updateBookmark];  // 페이지 변경시 책갈피 설정 버튼을 갱신합니다.
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    if (self.player == nil) {
        self.player = [eduPDFPlayer new];
        [self initPlayer];
    }    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.player isOpened]) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fdf_data_exchange" ofType:@"pdf"];
    
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    EDPageConfig *pageConfig = [EDPageConfig new];
    // 링크 영역에 강조 색상을 설정합니다. 설정하지 않으면 강조 표시를 하지 않습니다.
    pageConfig.linkHighlightColor = [UIColor colorWithRed:0.1 green:0.2 blue:1.0 alpha:0.1];
    docProvider.config = pageConfig;
    
    __weak ViewController *weakSelf = self; // 메모리 누수나지 않게 weak reference
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
        [weakSelf.mainPagebar layoutSubviews];  // 문서 오픈이 끝나면 페이지 네비게이션 바 섬네일을 전부 갱신합니다.
        [weakSelf.mainPagebar updatePagebar];   // 페이지 네비게이션 바에서 현재 페이지를 설정합니다.
        [weakSelf updateBookmark];  // 책갈피 설정 버튼을 갱신합니다.
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [self.player viewWillTransitionToSize:size withTransitionCoordinator:coordinator];  // 회전시 반드시 호출해야 합니다.
}

#pragma mark - ReaderMainPagebarDelegate

- (void)pagebar:(ReaderMainPagebar *)pagebar gotoPage:(NSInteger)page;
{
    // 페이지 네비게이션바를 통해 페이지를 이동 합니다.
    [self.player gotoPage:(int)page completion:^(EDPageMoveFinishedType finished) {
        NSLog(@"PageMove Finished code = %d", (int)finished);
    }];
}

#pragma mark - Outlines

- (IBAction)outlines:(id)sender // 목차 불러오기
{
    if ([self.player outlineCount] < 1) {
        return;
    }
    // 목차 컨트롤러를 생성합니다.
    CustomOutlines *ctrl = [[CustomOutlines alloc] initWithNibName:@"CustomOutlines" bundle:nil];
    
    // 목차 관리자가 목차를 접근하기 위해서는 eduPDFPlayer 핸들이 필요합니다.
    ctrl.player = self.player;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - Bookmark

- (void)updateBookmark  // 책갈피 설정 버튼을 갱신합니다.
{
    int pageNo = [self.player currentPageNo];
    
    self.bookmarkButton.selected = [self.player getBookmark:pageNo] != nil;
}

- (IBAction)bookmark:(id)sender // 책갈피를 추가/삭제 합니다.
{
    int pageNo = [self.player currentPageNo];
    if ([self.player getBookmark:pageNo]) {
        [self.player setBookmark:nil pageNo:pageNo];
    } else {
        EDBookmark *bookmark = [EDBookmark new];
        bookmark.pageNo = pageNo;
        [self.player setBookmark:bookmark pageNo:pageNo];
    }
    
    [self updateBookmark];
}

- (IBAction)bookmarks:(id)sender    // 책갈피 목록
{
    NSLog(@"------------------------- Bookmarks -------------------------");
    for (int pageNo=1; pageNo<=[self.player pageCount]; ++pageNo) {
        EDBookmark *bookmark = [self.player getBookmark:pageNo];
        if (bookmark) {
            NSLog(@"pageNo = %d memo = %@", bookmark.pageNo, bookmark.memo);
        }
    }
}

@end
