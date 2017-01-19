//
//  ViewController.m
//  Open
//
//  Created by puttana on 2017. 1. 9..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import "ViewController.h"
#import "MyDataProvider.h"

@interface ViewController ()

@property(nonatomic, strong) eduPDFPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    if (self.player == nil) {
        self.player = [eduPDFPlayer new];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.player didReceiveMemoryWarning];  // 메모리 부족할 때 호출 필요
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self openLocalPath];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [self.player viewWillTransitionToSize:size withTransitionCoordinator:coordinator];  // 회전시 반드시 호출해야 합니다.
}

- (IBAction)openLocalPath   // 로컬 경로로 문서를 열람 합니다.
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"adobe_supplement_iso32000" ofType:@"pdf"];
    
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
}

- (IBAction)openStream  // 스트림으로 문서를 열람합니다.
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fdf_data_exchange" ofType:@"pdf"];
    
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;    // 경로 값은 문서에 대한 고유키로 사용합니다. 설정하지 않으면 랜덤하게 고유키가 설정 됩니다.
    docProvider.inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    
    // 스트림으로 문서를 열람하는 경우는 오픈 시간이 파일크기에 비례하여 소요됩니다.
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
}

- (IBAction)openDataProvider    // DataProvider를 통해 문서를 열람 합니다.
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XML Forms Data Format (XFDF) Specification - Adobe Partners" ofType:@"pdf"];
    
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;    // 경로 값은 문서에 대한 고유키로 사용합니다. 설정하지 않으면 랜덤하게 고유키가 설정 됩니다.
    docProvider.dataProvider = [[MyDataProvider alloc] initWithPath:path];  // 문서 바이너리 제공 구현 직접합니다.
    
    // DataProvider으로 문서를 열람하는 경우는 랜덤 액세스를 하기 때문에 바로 열람 가능 합니다.
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
}

- (IBAction)openRemoteURL   // 원격 URL을 통해 문서를 열람 합니다.
{
    NSString *path = @"http://www.cu-book.com/manga_Sample.o3.pdf";
    
    // 열람 문서가 웹툰형이라 웹툰뷰어와 같이 설정을 합니다.
    EDPageConfig *pageConfig = [EDPageConfig new];
    pageConfig.pageScrollDirectionStyle = EDPageScrollDirectionVertical;    // 세로 스크롤
    pageConfig.pageFittingStyle = EDPageFittingWidth;   // 가로 피팅
    pageConfig.pagingEnabled = NO;  // 연속 보기
    pageConfig.margin = 0;  // 페이지간 간격 없음
    pageConfig.backgroundColor = [UIColor blackColor];  // 배경은 검은색
    pageConfig.documentPageLayout = NO; // 문서에 페이지 레이아웃 설정을 따르지 않음

    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    docProvider.config = pageConfig;
    
    // 해당 URL의 경우 서버가 스트리밍(FastOpen or ByteServing)을 지원하므로 열람시 필요한 데이터만 다운로드 받습니다.
    // 페이지를 넘기면 비동기로 필요한 데이터를 실시간으로 내려받습니다.
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
}
@end
