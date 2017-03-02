//
//  ViewController.m
//  Coordination
//
//  Created by puttana on 2017. 2. 15..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import "ViewController.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>

@interface ViewController ()

@property(nonatomic, strong) eduPDFPlayer *player;
@property(nonatomic, weak) EDPageConfig *config;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.player = [eduPDFPlayer new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"adobe_supplement_iso32000" ofType:@"pdf"];
    
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    EDPageConfig *config = [EDPageConfig new];
    config.flipEffect = NO; // 페이지 넘김 효과 사용 안함.
    config.displayPageCount = 1;    // 한장씩 보기
    config.blankPageCount = 1;  // 첫장 빈 페이지
    config.pagingEnabled = NO;
    config.pageScrollDirectionStyle = EDPageScrollDirectionHorizontal;
    docProvider.config = config;
    self.config = config;
    
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
    
    [self.player setChangedZoom:^(EDTouchCoordination * _Nullable coord) {
        NSLog(@"setChangedZoom = %d bounds=%@", (int)coord.pageNo, [NSValue valueWithCGRect:coord.boundsInnerView]);
    }];
    
    [self.player setChangedScroll:^(EDTouchCoordination * _Nullable coord) {
        NSLog(@"setChangedScroll = %d bounds=%@", (int)coord.pageNo, [NSValue valueWithCGRect:coord.boundsInnerView]);
    }];
}

- (IBAction)zoom:(id)sender
{
    // 현재 페이지에 대한 좌표 객체을 얻어와서
    EDTouchCoordination *coord = [self.player touchCoordination:[self.player currentPageNo]];
    
    CGRect f = coord.frameInnerView;    // 페이지 뷰 frame값
    CGFloat r = f.size.height/f.size.width;
    
    // 좌측 상단 영역에 확대를 합니다.
    f.size.width /= 2.0;
    f.size.height = f.size.width * r;
    coord.frameInnerView = f;
    
    [self.player zoomToRect:coord];
}

- (IBAction)scroll:(id)sender
{
    EDTouchCoordination *coord = [self.player touchCoordination:[self.player currentPageNo]];
    
    CGRect f = coord.frameInnerView;    // 페이지 뷰 frame값
    CGFloat r = f.size.height/f.size.width;
    
    // 우측 상단으로 이동 합니다.
    f.size.width /= 2.0;
    f.size.height = f.size.width * r;
    f.origin.x += f.size.width;
    coord.frameInnerView = f;
    
    [self.player scrollToRect:coord];
}

- (IBAction)zoomRect:(UIButton *)sender
{
    EDTouchCoordination *coord = [self.player touchCoordination:[self.player currentPageNo]];
    
    // 버튼위치에 해당하는 디스플레이 좌표를 페이지뷰 좌표로 변경하여 확대를 합니다.
    CGRect f = [coord innerViewRectFromDisplayRect:sender.frame];
    coord.frameInnerView = f;
    
    [self.player zoomToRect:coord];
}


- (IBAction)zoomOrigin:(UIButton *)sender
{
    // 현재 페이지로 축소 합니다.
    EDTouchCoordination *coord = [self.player touchCoordination:[self.player currentPageNo]];
    
    [self.player zoomToRect:coord];
}

- (IBAction)zoomDocumentRect:(id)sender
{
    EDTouchCoordination *coord = [self.player touchCoordination:[self.player currentPageNo]];
    
    // 페이지 문서 좌표를 가져 옵니다.
    CGRect docRect = coord.frameOrigin;
    CGFloat r = docRect.size.height/docRect.size.width;
    // 우측 하단으로 확대 합니다. 문서 좌표계는 수학 좌표계 입니다. 그래서 하단 좌측이 0, 0 입니다.
    docRect.size.width /= 2.0;
    docRect.size.height = docRect.size.width * r;
    docRect.origin.x += docRect.size.width;
    
    CGRect f = [coord innerViewRect:docRect];
    coord.frameInnerView = f;
    
    [self.player zoomToRect:coord];
}
@end
