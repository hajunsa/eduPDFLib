//
//  ViewController.m
//  ViewMode
//
//  Created by 허기수 on 2017. 1. 21..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import <eduPDFPlayerS/eduPDFPlayer.h>
#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) eduPDFPlayer *player;
@property(nonatomic, weak) EDPageConfig *config;
@property(nonatomic, weak) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.player = [eduPDFPlayer new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"뷰어 테스트_샘플 완료_161108" ofType:@"pdf"];
    
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    EDPageConfig *config = [EDPageConfig new];
    config.flipEffect = NO; // 페이지 넘김 효과 사용 안함.
    config.displayPageCount = 1;    // 한장씩 보기
    config.blankPageCount = 1;  // 첫장 빈 페이지
    config.pagingEnabled = YES;
    config.pageScrollDirectionStyle = EDPageScrollDirectionHorizontal;
    config.backgroundColor = [UIColor redColor];
    docProvider.config = config;
    self.config = config;
    
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [self.player viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (IBAction)colorGrayToggle:(UIButton *)sender  // 흑백 보기 전환
{
    sender.selected = !sender.selected;
    
    self.config.blackAndWhite = sender.selected;
    if (self.config.blackAndWhite) {
        self.slider.enabled = YES;
    }
    
    [self.player reload];
}

- (IBAction)darknessChange:(UISlider *)sender // 흑백 보기 음영 강도 설정
{
    self.config.darkness = sender.value;
    [self.player reload];
}


- (IBAction)pageFlipMode:(UIButton *)sender // 페이지 플립 효과 전환
{
    sender.selected = !sender.selected;
    self.config.flipEffect = sender.selected;
    [self.player reload];
}


- (IBAction)doublePage:(UIButton *)sender // 양면 보기 전환
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.config.displayPageCount = 2;
    } else {
        self.config.displayPageCount = 1;
    }
    [self.player reload];
}

- (IBAction)prevPage:(id)sender
{
    [self.player prevPage:^(EDPageMoveFinishedType finished) {
        
    }];
}

- (IBAction)nextPage:(id)sender
{
    [self.player nextPage:^(EDPageMoveFinishedType finished) {
        
    }];
}
@end
