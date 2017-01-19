//
//  ViewController.m
//  Annotation
//
//  Created by 허기수 on 2016. 12. 29..
//  Copyright © 2016년 Unidocs Inc. All rights reserved.
//

#import "ViewController.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>

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
    if (![touchCoord.annotation isMarkup]) {    // 마크업 주석만 메뉴를 뛰웁니다.
        return;
    }
    [self becomeFirstResponder];    // 입력 응답을 받을 수 있게 합니다.

    NSString *lockTitle = [touchCoord.annotation isLocked] ? @"잠금해제" : @"잠금";
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"속성" action:@selector(propertiesAnnot:)], [[UIMenuItem alloc] initWithTitle:@"내용수정" action:@selector(contentsAnnot:)], [[UIMenuItem alloc] initWithTitle:lockTitle action:@selector(toggleLockAnnot:)], [[UIMenuItem alloc] initWithTitle:@"아이콘" action:@selector(nameAnnot:)], [[UIMenuItem alloc] initWithTitle:@"외곽선색상" action:@selector(borderColorAnnot:)],[[UIMenuItem alloc] initWithTitle:@"외곽선크기" action:@selector(borderWidthAnnot:)], [[UIMenuItem alloc] initWithTitle:@"투명도" action:@selector(opacityAnnot:)], [[UIMenuItem alloc] initWithTitle:@"채움색상" action:@selector(fillColorAnnot:)], [[UIMenuItem alloc] initWithTitle:@"머리모양" action:@selector(headAnnot:)], [[UIMenuItem alloc] initWithTitle:@"꼬리모양" action:@selector(tailAnnot:)], [[UIMenuItem alloc] initWithTitle:@"텍스트크기" action:@selector(fontSizeAnnot:)], [[UIMenuItem alloc] initWithTitle:@"텍스트색상" action:@selector(fontColorAnnot:)], [[UIMenuItem alloc] initWithTitle:@"삭제" action:@selector(deleteAnnot:)]]];
    if (inView) {
        [menuController setTargetRect:targetRect inView:inView];
    }
    [menuController setMenuVisible:YES animated:YES];
}

- (void)showMenuText:(EDTouchCoordination *)touchCoord targetRect:(CGRect)targetRect inView:(UIView *)inView
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"강조" action:@selector(highlightAnnot:)], [[UIMenuItem alloc] initWithTitle:@"취소선" action:@selector(strikeOutAnnot:)], [[UIMenuItem alloc] initWithTitle:@"밑줄" action:@selector(underlineAnnot:)]]];
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
            case EDTouchTextSelection:
                [weakSelf showMenuText:touchCoord targetRect:touchCoord.text.frame inView:touchCoord.objectView.superview];    // 텍스트 선택시 메뉴를 뛰웁니다.
                break;
            case EDTouchAnnotation: // 주석 선택시
            {
                if (![weakSelf canBecomeFirstResponder]) {
                    NSLog(@"couldn't become first responder");
                    return;
                }
                
                [weakSelf showMenu:touchCoord targetRect:touchCoord.objectView.frame inView:touchCoord.objectView.superview];    // 주석 선택시 메뉴를 뛰웁니다.
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.player = [eduPDFPlayer new];
    [self initPlayer];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"fdf_data_exchange" ofType:@"pdf"];
    
    EDDocumentProvider *docProvider = [EDDocumentProvider new];
    docProvider.superview = self.view;
    docProvider.path = path;
    EDPageConfig *config = [EDPageConfig new];
    // 주석 선택시 외곽 색상을 설정 합니다. 설정하지 않으면 기본색상을 사용합니다.
    config.annotationSelectionBorderColor = [UIColor colorWithRed:0.1 green:0.2 blue:1.0 alpha:1.0];
    docProvider.config = config;
    
    [self.player openWithDocProvider:docProvider completion:^(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished) {
        NSLog(@"Open Finished code = %d", (int)finished);
    }];
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
    if (self.touchCoord.annotation) {  // 주석을 선택했을 때 설정 가능한 메뉴를 뛰웁니다.
        if (selector == @selector(propertiesAnnot:)) {
            return YES;
        }
        if (selector == @selector(borderColorAnnot:)) {
            return YES;
        }
        if (selector == @selector(contentsAnnot:)) {
            return YES;
        }
        if (selector == @selector(toggleLockAnnot:)) {
            return YES;
        }
        if (selector == @selector(opacityAnnot:)) {
            return YES;
        }
        if ([self.touchCoord.annotation fillColorAble]) {
            if (selector == @selector(fillColorAnnot:)) {
                return YES;
            }
        }
        if ([self.touchCoord.annotation fontSizeAble]) {
            if (selector == @selector(fontSizeAnnot:)) {
                return YES;
            }
            if (selector == @selector(fontColorAnnot:)) {
                return YES;
            }
        }
        if ([self.touchCoord.annotation borderWidthAble]) {
            if (selector == @selector(borderWidthAnnot:)) {
                return YES;
            }
        }
        if ([self.touchCoord.annotation nameAble]) {
            if (selector == @selector(nameAnnot:)) {
                return YES;
            }
        }
        if ([self.touchCoord.annotation headTailAble]) {
            if (selector == @selector(headAnnot:)) {
                return YES;
            }
        }
        if ([self.touchCoord.annotation headTailAble]) {
            if (selector == @selector(tailAnnot:)) {
                return YES;
            }
        }
        if ([self.touchCoord.annotation removeAble]) {
            if (selector == @selector(deleteAnnot:)) {
                return YES;
            }
        }
    } else if (self.touchCoord.annotMakerParam) {
        if (selector == @selector(highlightAnnot:)) {
            return YES;
        }
        if (selector == @selector(underlineAnnot:)) {
            return YES;
        }
        if (selector == @selector(strikeOutAnnot:)) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)underlineAnnot:(id)sender
{
    self.touchCoord.annotMakerParam.type = @"Underline";
    [self.player markupAnnotationInsert:self.touchCoord.annotMakerParam];
    [self.player clearSelection];   // 텍스트 선택 영역을 제거
}

- (IBAction)strikeOutAnnot:(id)sender
{
    self.touchCoord.annotMakerParam.type = @"StrikeOut";
    [self.player markupAnnotationInsert:self.touchCoord.annotMakerParam];
    [self.player clearSelection];   // 텍스트 선택 영역을 제거
}

- (IBAction)highlightAnnot:(id)sender
{
    self.touchCoord.annotMakerParam.type = @"Highlight";
    [self.player markupAnnotationInsert:self.touchCoord.annotMakerParam];
    [self.player clearSelection];   // 텍스트 선택 영역을 제거
}

- (IBAction)deleteAnnot:(id)sender  // 주석 삭제
{
    [self.touchCoord.annotation removeFromPage];
    self.touchCoord.annotation = nil;
}

- (IBAction)borderColorAnnot:(id)sender // 외곽선 색상 설정
{
    [self.touchCoord.annotation syncBorderColor:[UIColor yellowColor]];
}

- (IBAction)fillColorAnnot:(id)sender   // 채움 색상 설정
{
    [self.touchCoord.annotation syncFillColor:[UIColor redColor]];
}

- (IBAction)borderWidthAnnot:(id)sender // 외곽선 굵기 설정
{
    [self.touchCoord.annotation syncBorderWidth:4];
}

- (IBAction)opacityAnnot:(id)sender // 투명도 설정
{
    [self.touchCoord.annotation syncOpacity:0.5];
}

- (IBAction)nameAnnot:(id)sender;   // Sticky Note(Text) 아이콘 설정
{
    [self.touchCoord.annotation syncName:@"Check"];
}

- (IBAction)headAnnot:(id)sender;   // Line 머리 모양 설정
{
    [self.touchCoord.annotation syncHead:@"RightArrow"];
}

- (IBAction)tailAnnot:(id)sender;   // Line 꼬리 모양 설정
{
    [self.touchCoord.annotation syncTail:@"OpenArrow"];
}

- (IBAction)fontSizeAnnot:(id)sender;   // FreeText 폰트 크기 설정
{
    [self.touchCoord.annotation syncFontSize:36];
}

- (IBAction)fontColorAnnot:(id)sender;   // FreeText 폰트 색상 설정
{
    [self.touchCoord.annotation syncFontColor:[UIColor redColor]];
}

- (IBAction)toggleLockAnnot:(id)sender; // 위치 잠금 설정
{
    BOOL lock = ![self.touchCoord.annotation isLocked];
    [self.touchCoord.annotation syncLock:lock];
    [self showMenu:self.touchCoord targetRect:CGRectZero inView:nil]; // 메뉴를 다시 뛰웁니다.
}

- (IBAction)contentsAnnot:(id)sender    // 내용 설정
{
    [self.touchCoord.annotation syncContents:@"My name is ..."];
    [self.player clearSelection];   // 선택을 해제 합니다.
    self.touchCoord.annotation = nil;
}

- (IBAction)propertiesAnnot:(id)sender    // 전체 속성 설정
{
    self.touchCoord.annotation.borderWidth = 10;
    self.touchCoord.annotation.borderColor = [UIColor greenColor];
    self.touchCoord.annotation.fillColor = [UIColor magentaColor];
    self.touchCoord.annotation.opacity = 0.8;
    [self.touchCoord.annotation setLocked:YES];
    self.touchCoord.annotation.contents = @"Who ...";
    self.touchCoord.annotation.fontSize = 60;
    [self.touchCoord.annotation syncSelf];
}

#pragma mark - XFDF Import/Export

- (IBAction)exportAnnot:(id)sender  // 주석 내보내기
{
    self.addAnnotLabel.text = nil;  // exportXFDF를 하면 주석 추가 모드(markupAnnotationInsert)가 취소 됩니다.
    EDXFDFParam *param = [EDXFDFParam new];
    [self.player exportXFDF:param];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"xfdf.xml"];
    [param.data writeToFile:path atomically:YES];
}

- (IBAction)importAnnot:(id)sender  // 주석 가져오기
{
    EDXFDFParam *param = [EDXFDFParam new];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"xfdf.xml"];
    param.path = path;
    [self.player importXFDF:param];
}

#pragma mark - Add Annotation

- (IBAction)addAnnot:(UIButton *)sender // 사용자 터치 입력 주석 추가하기
{
    self.player.annotationInserting = NO;   // Ink의 경우 입력 중 이면 해당 주석을 문서에 추가합니다.
    
    // markupAnnotationParam를 통해 주석 생성 매개변수를 생성하면 현재 설정중인 각 종류별 속성값을 가져옵니다.
    static int type = 0;
    switch (type) {
        case 0:
            self.annotMakerParam = [self.player markupAnnotationParam:@"Ink"];
            break;
        case 1:
            self.annotMakerParam = [self.player markupAnnotationParam:@"FreeText"];
            break;
        case 2:
            self.annotMakerParam = [self.player markupAnnotationParam:@"Text"];
            break;
        case 3:
            self.annotMakerParam = [self.player markupAnnotationParam:@"Line"];
            // @"None", @"OpenArrow", @"Square", @"Circle"
            self.annotMakerParam.head = @"OpenArrow";
            self.annotMakerParam.tail = @"Circle";
            break;
        case 4:
            self.annotMakerParam = [self.player markupAnnotationParam:@"Circle"];
            break;
        case 5:
            self.annotMakerParam = [self.player markupAnnotationParam:@"Stamp"];
            self.annotMakerParam.image = [UIImage imageNamed:@"94_1436254771905.jpeg"];
            break;
        case 6:
            self.annotMakerParam = [self.player markupAnnotationParam:@"StrikeOut"];
            break;
        case 7:
            self.annotMakerParam = [self.player markupAnnotationParam:@"Underline"];
            break;
        case 8:
            self.annotMakerParam = [self.player markupAnnotationParam:@"Highlight"];
            break;
        case 9:
            self.annotMakerParam = [self.player markupAnnotationParam:@"Square"];
            break;
        default:
            break;
    }
    
    self.player.annotationInserting = YES; // 주석 추가 시작
    self.addAnnotLabel.text = self.annotMakerParam.type;
    // annotMakerParam을 설정하여 외부에서 속성값을 수정하면 입력시 바로 반영합니다.
    [self.player markupAnnotationInsert:self.annotMakerParam];
    type++;
    if (type >= 10) {
        type = 0;
    }
}

- (IBAction)eraserAnnot:(id)sender
{
    self.player.annotationInserting = YES;  // 지우개로 주석 삭제시에도 추가와 동일한 API를 사용합니다.
    self.annotMakerParam = [self.player markupAnnotationParam:@"Eraser"]; // 주석 지우개
    self.addAnnotLabel.text = self.annotMakerParam.type;
    [self.player markupAnnotationInsert:self.annotMakerParam];
    
}

- (IBAction)selectAnnot:(id)sender
{
    [self stopAnnot:nil];
    [self.player selectAnnotation:self.willSelectionAnnotation completion:^(BOOL cancel) {
        if (!cancel) {
            NSLog(@"Annotation Selected");
        }
    }];
}

- (IBAction)stopAnnot:(UIButton *)sender    // 사용자 터치 입력 주석 추가하기 중지
{
    self.addAnnotLabel.text = nil;
    self.player.annotationInserting = NO;   // Ink의 경우 입력 중 이면 해당 주석을 문서에 추가합니다.
}

- (IBAction)annotList:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0L), ^{  // 페이지가 많은 경우 주석 가져오는 시간이 오래 걸리수 있기 때문에 스레드로 주석을 가져오도록 하였습니다.
        for (int pageNo=1; pageNo<=[self.player pageCount]; ++pageNo) { // 모든 페이지에서
            NSArray<EDAnnotation *> *annots = [self.player getAnnotations:pageNo];  // 해당 페이지 주석을 가져옵니다.
            dispatch_async(dispatch_get_main_queue(), ^{    // 가져온 결과를 메인 스레드에서 처리합니다. 테이블 뷰어에서 구현시 응용하기 바랍니다.
                NSLog(@"----------- pageNo = %d annots count = %lu -----------", pageNo, [annots count]);
                for (EDAnnotation *annot in annots) {
                    if ([annot isMarkup]) { // 마크업(사용자가 입력하는) 주석만 목록에서 보여줍니다.
                        NSLog(@"Annotation type = %@, date = %@, contents = %@", annot.type, annot.date, annot.contents);
                    }
                }
            });
        }
    });
}
@end
