//
//  ViewController.m
//  Writer
//
//  Created by puttana on 2017. 1. 26..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import "ViewController.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>
#import "MyPrintPageRenderer.h"

@interface ViewController ()

@property(nonatomic, strong) eduPDFPlayer *player;
@property(nonatomic, strong) IBOutlet UILabel *addAnnotLabel;
@property(nonatomic, strong) EDMarkupAnnotationParam *annotMakerParam;

@property(nonatomic, strong) EDTouchCoordination *touchCoord;

@property(nonatomic, weak) EDAnnotation *willSelectionAnnotation;

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

// 주석 속성 수정 컨텍스 메뉴
- (void)showMenu:(EDTouchCoordination *)touchCoord targetRect:(CGRect)targetRect inView:(UIView *)inView
{
    [self becomeFirstResponder];    // 입력 응답을 받을 수 있게 합니다.
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"링크추가" action:@selector(extentionLink:)]]];
    if (inView) {
        [menuController setTargetRect:targetRect inView:inView];
    }
    [menuController setMenuVisible:YES animated:YES];
}

- (void)initPlayer
{
    __weak eduPDFPlayer *player = self.player;
    __weak ViewController *weakSelf = self; // 메모리 누수나지 않게 weak reference
    [self.player setTouchOneTap:^(EDTouchCoordination *touchCoord) {    // 페이지 원탭후 호출
        weakSelf.touchCoord = touchCoord;    // 마지막 터치 입력
        switch (touchCoord.type) {
            case EDTouchPage:
                if (player.annotationInserting) {   // 주석 입력 중 이면
                    if ([touchCoord.annotMakerParam.type isEqualToString:@"Text"] || [touchCoord.annotMakerParam.type isEqualToString:@"FreeText"]) { // (Sticky Note, Free Text)
                        touchCoord.annotMakerParam.contents = @"녕"; // 컨텐츠 내용을 수정하였습니다.
                        touchCoord.annotMakerParam.isCompletion = YES; // 문서에 주석을 추가 하기 위한 설정입니다.
                        [player markupAnnotationInsert:touchCoord.annotMakerParam];
                    }
                }
                break;
            default:
                break;
        }
        NSLog(@"touchOneTap point = %@ frame = %@", [NSValue valueWithCGPoint:touchCoord.pointDisplay], [NSValue valueWithCGRect:touchCoord.frameDisplay]);
    }];
    
    [self.player setAddedAnnotation:^(EDAnnotation *annot) { // 주석이 추가 됬을 때
        NSLog(@"Added annotation type=%@, name=%@", annot.type, annot.nm);
        weakSelf.willSelectionAnnotation = annot;    // 추가한 주석을 선택히기위한 주석으로 설정. 주석 선택을 예제를 위한 의도적인 코드이니 참고만 하세요.
    }];
    [self.player setRemovedAnnotation:^(EDAnnotation *annot) {  // 주석이 삭제 됬을 때
        NSLog(@"Removed annotation type=%@, name=%@", annot.type, annot.nm);
    }];
    [self.player setModifiedAnnotation:^(EDAnnotation *annot) { // 주석이 수정 됬을 때
        NSLog(@"Modified annotation type=%@, name=%@", annot.type, annot.nm);
    }];
    
    [self.player setLoadedPage:^(int pageNo) {
        NSLog(@"loaded page = %d", pageNo);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.player = [eduPDFPlayer new];
    [self initPlayer];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fdf_data_exchange" ofType:@"pdf"];
    [self open:path];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [self.player viewWillTransitionToSize:size withTransitionCoordinator:coordinator];  // 회전시 반드시 호출해야 합니다.
}

- (void)open:(NSString *)path
{
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    EDPageConfig *config = [EDPageConfig new];
    // 주석 선택시 외곽 색상을 설정 합니다. 설정하지 않으면 기본색상을 사용합니다.
    config.annotationSelectionBorderColor = [UIColor colorWithRed:0.1 green:0.2 blue:1.0 alpha:1.0];
    config.pagingEnabled = YES;
    config.xpdfPageRenderingWithCoreGraphic = YES;
    config.backgroundColor = [UIColor redColor];
    docProvider.config = config;
    
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
}

#pragma mark - UIMenuController

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)selector withSender:(id)sender {
    if (self.touchCoord) {
        if (selector == @selector(extentionLink:)) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)extentionLink:(id)sender
{
    // 미구현
}

#pragma mark - Action
- (IBAction)createBlankPDF:(id)sender // 빈 문서 생성
{
    EDDocumentMakeParam *param = [EDDocumentMakeParam new];
    param.paperColor = [UIColor purpleColor];   // 배경 색상을 지정하고
    NSData *data = [eduPDFWriter creatBlankDocumentFile:param]; // 빈문서를 생성하여
    [data writeToFile:param.path atomically:YES]; // 해당 위치에 저장 합니다.
    [self open:param.path]; // 저장한 문서를 열람합니다.
}

- (IBAction)displayImageInPDF:(id)sender // PDF 이미지 표시하기
{
    EDImageMakeParam *param = [EDImageMakeParam new];
    param.pageNo = [self.player currentPageNo]; // 현재 페이지에
    param.image = [UIImage imageNamed:@"PNG_transparency_demonstration_1"]; // 표시할 이미지
    [self.player appendImageInPage:param];
}

- (IBAction)insetPage:(id)sender    // 빈 페이지 추가하기
{
    EDPageMakeParam *param = [EDPageMakeParam new];
    param.pageNo = [self.player currentPageNo]; // 현재 페이지 다음 부터
    param.count = 5;    // 5개 빈 페이지를 추가합니다.
    param.complationPageNo = 1; // 완료하고 1페이지로 이동합니다.
    [self.player insertPage:param];
}

- (IBAction)duplicatePage:(id)sender    // 페이지 복제하기
{
    EDPageMakeParam *param = [EDPageMakeParam new];
    param.pageNo = [self.player currentPageNo]; // 현재 페이지를
    param.count = 5;    // 5개 복제하여 다음 페이지에 넣습니다.
    param.complationPageNo = 1; // 완료하고 1페이지로 이동합니다.
    [self.player duplicatePage:param];
}

- (IBAction)removePage:(id)sender   // 페이지 삭제하기
{
    EDPageMakeParam *param = [EDPageMakeParam new];
    param.pageNo = [self.player currentPageNo]; // 현재 페이지를 포함하여
    param.count = 5; // 연속한 5개 페이지를 삭제 합니다.
    param.complationPageNo = 1; //완료하고 1페이지로 이동합니다.
    [self.player removePage:param];
}

- (IBAction)print:(id)sender
{
    if (![self.player isPrintAble]) {
        return;
    }

    Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
    
    if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
    {
        UIPrintInteractionController *printInteraction = [printInteractionController sharedPrintController];
        UIPrintInfo *printInfo = [NSClassFromString(@"UIPrintInfo") printInfo];
        
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [self.player.openedPath lastPathComponent];
        
        printInteraction.printInfo = printInfo;
        MyPrintPageRenderer *renderer = [[MyPrintPageRenderer alloc]init];
        renderer.player = self.player;
        printInteraction.printPageRenderer = renderer;
        
        [printInteraction presentFromRect:self.view.bounds inView:self.view animated:YES completionHandler:
         ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
         {
#ifdef DEBUG
             if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
#endif
         }];
    }
}
@end
