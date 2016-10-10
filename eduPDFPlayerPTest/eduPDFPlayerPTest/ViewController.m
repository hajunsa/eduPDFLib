//
//  ViewController.m
//  eduPDFPlayerPTest
//
//  Created by puttana on 2016. 9. 13..
//  Copyright © 2016년 Unidocs. All rights reserved.
//

#import "ViewController.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>

@interface ViewController ()

@property(strong) eduPDFPlayer *player;

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
    NSString *path = @"http://www.cu-book.com/manga_Sample.o3.pdf";
    EDPageConfig *pageConfig = [EDPageConfig new];
    pageConfig.pageScrollDirectionStyle = EDPageScrollDirectionVertical;
    pageConfig.pageFittingStyle = EDPageFittingWidth;
    pageConfig.pageReadDirectionStyle = EDPageReadDirectionRight;
    pageConfig.displayPageCount = 1;
    pageConfig.blankPageCount = 0;
    pageConfig.pagingEnabled = NO;
    pageConfig.margin = 0.0;
    pageConfig.initPageNo = 1;
    pageConfig.backgroundColor = [UIColor blackColor];
    
    self.player = [eduPDFPlayer new];
    [self.player openWithPath:path superview:self.view config:pageConfig completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        // 현재 페이지 변경됬을 때 하단 페이지 바 업데이트
        [self.player setChangedPage:^(int pageNo) {
            if (pageNo == [self.player pageCount]) {
                // Footer Page
            }
            NSLog(@"changedPage pageNo = %d", pageNo);
        }];
        
        // 스크롤 시작 할때
        [self.player setStartScroll:^(int pageNo) {
            NSLog(@"startScroll pageNo = %d", pageNo);
        }];

        // 스크롤을 드레깅 방향으로 더 이상 할 수 없을 때
        [self.player setLimitScroll:^(int pageNo) {
            NSLog(@"limitScroll pageNo = %d", pageNo);
        }];

        NSLog(@"Open Finished code = %d", (int)finished);
    }];
}

@end
