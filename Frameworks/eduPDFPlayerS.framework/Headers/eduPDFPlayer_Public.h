//
//  eduPDFPlayer.h
//  eduPDFView
//
//  Created by 허기수 on 2016. 7. 23..
//  Copyright © 2016년 Unidocs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EDFooter.h"
#import "EDHTTPConfig.h"
#import "EDDataProvider.h"

#if EDLIB_TEST
#import "EDPageEnums.h"

@class EDPageConfig;
#else
#import "EDPageConfig.h"
#endif

/**
 *  eduPDF Player.
 *  PDF, Zipped-Image 열람 가능합니다.
 *  eduPDF 기능을 사용할 수 있습니다.
 */
@interface eduPDFPlayer : NSObject

/**
 *  열람시 필요한 패스워드.
 */
@property(nonatomic, strong) NSString * __nullable password;

/**
 *  페이지 위에서 단일 탭 액션이 발생 했을 때 콜백 클로저.
 *  페이지 밖에서 단일 탭이 일어나면 호출하지 않습니다.
 *  페이지 안에서 특정 객체(주석, 텍스트, 미디어 등등)가 단일 탭 처리를 할 경우 호출하지 않습니다.
 */
@property(nonatomic, copy, setter=setTouchOneTap:) void (^__nullable touchOneTap)(CGPoint pt);

/**
 *  현재 페이지가 변경 됬을 때 콜백 클로저.
 */
@property(nonatomic, copy, setter=setChangedPage:) void (^__nullable changedPage)(int pageNo);

/**
 *  문서 열람.
 *
 *  @param path 문서 로컬 경로 또는 원격 경로(http, https).
 *  @param superview 화면 표시될 부모 뷰어.
 *  @param completion 열람 완료시 콜백 클로저.
 */
- (void)openWithPath:(nonnull NSString *)path superview:(nonnull UIView *)superview completion:(void (^ __nullable)(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished))completion;
/**
 *  문서 열람.
 *
 *  @param path 문서 로컬 경로 또는 원격 경로(http, https).
 *  @param superview 화면 표시될 부모 뷰어.
 *  @param config 페이지 관련 설정.
 *  @param completion 열람 완료시 콜백 클로저.
 */
- (void)openWithPath:(nonnull NSString *)path superview:(nonnull UIView *)superview config:(nullable EDPageConfig *)config completion:(void (^ __nullable)(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished))completion;

/**
 *  문서 열람.
 *  외부 DRM이나 데이터 변환이 필요한 경우에 사용합니다.
 *  EDDataProvider 상속받아 convertData 인터페이스를 직접 구현 합니다.
 *
 *  @param dataProvider 문서 데이터 제공자.
 *  @param superview 화면 표시될 부모 뷰어.
 *  @param config 페이지 관련 설정.
 *  @param completion 열람 완료시 콜백 클로저.
 */
- (void)openWithDataProvider:(nonnull EDDataProvider *)dataProvider superview:(nonnull UIView *)superview config:(nullable EDPageConfig *)config completion:(void (^ __nullable)(eduPDFPlayer * _Nonnull player, eduPDFOpenFinishedType finished))completion;

/**
 *  문서 닫기.
 */
- (void)close;

/**
 *  장치 회전 처리.
 *  장치 회전시 해당 값을 그대로 호출 합니다.
 *  iOS 8.0 이상
 *
 *  @param size 받은값 그대로 전달.
 *  @param coordinator 받은값 그대로 전달.
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0);

/**
 *  장치 회전 처리.
 *  장치 회전시 해당 값을 그대로 호출 합니다.
 *  iOS 8.0 미만
 *
 *  @param toInterfaceOrientation 받은값 그대로 전달.
 *  @param duration 받은값 그대로 전달.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration NS_DEPRECATED_IOS(2_0,8_0, "Implement viewWillTransitionToSize:withTransitionCoordinator: instead") __TVOS_PROHIBITED;

/**
 *  장치 회전 처리.
 *  장치 회전시 해당 값을 그대로 호출 합니다.
 *  iOS 8.0 미만
 *
 *  @param fromInterfaceOrientation 받은값 그대로 전달.
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation NS_DEPRECATED_IOS(2_0,8_0) __TVOS_PROHIBITED;

/**
 *  총 페이지 수.
 *
 *  @return 총 페이지 수.
 */
- (int)pageCount;

/**
 *  현재 페이지 번호.
 *
 *  @return 현재 페이지 번호.
 */
- (int)currentPageNo;

/**
 *  특정 페이지 이동.
 *
 *  @param pageNo 이동할 페이지 번호.
 *  @param completion 페이지 이동 완료시 콜백 클로저.
 */
- (void)gotoPage:(int)pageNo completion:(void (^ __nullable)(EDPageMoveFinishedType finished))completion;

/**
 *  다음 페이지 이동.
 *
 *  @param completion 페이지 이동 완료시 콜백 클로저.
 */
- (void)nextPage:(void (^ __nullable)(EDPageMoveFinishedType finished))completion;

/**
 *  이전 페이지 이동.
 *
 *  @param completion 페이지 이동 완료시 콜백 클로저.
 */
- (void)prevPage:(void (^ __nullable)(EDPageMoveFinishedType finished))completion;

/**
 *  페이지 섬네일 이미지 생성하여 얻기.
 *  생성한 이미지는 가로 세로 비율이 유지합니다. 레티나 디스플레이 이면 배율 만큼 생성한 이미지가 큽니다.
 *
 *  @param maxSize 생성할 이미지 최대 크기(1x 기준).
 *  @param pageNo 생성할 페이지 번호.
 *  @param completion 페이지 섬네일 이미지 생성 완료시 콜백 클로저.
 */
- (void)createPageThumbnailImage:(CGSize)maxSize pageNo:(int)pageNo completion:(void (^ __nullable)(UIImage * __nullable image, int pageNo))completion;

@end
