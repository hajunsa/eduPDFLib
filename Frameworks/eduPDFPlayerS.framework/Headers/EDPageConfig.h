//
//  EDPageConfig.h
//  eduPDFView
//
//  Created by 허기수 on 2016. 5. 27..
//  Copyright © 2016년 Unidocs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDPageEnums.h"
#import "EDFooter.h"

/**
 *  문서 페이지 관련 설정.
 */
@interface EDPageConfig : NSObject

/**
 *  문서 열람시 최초로 표시할 페이지 번호.
 *  기본값 : 1
 */
@property(nonatomic, assign) int initPageNo;
/**
 *  페이지 스크롤 방향.
 *  기본값 : EDPageScrollDirectionHorizontal
 */
@property(nonatomic, assign) EDPageScrollDirectionStyle pageScrollDirectionStyle;
/**
 *  페이지 읽기 방향.
 *  기본값 : EDPageReadDirectionAuto
 */
@property(nonatomic, assign) EDPageReadDirectionStyle pageReadDirectionStyle;
/**
 *  문서 페이지 화면 피팅 스타일.
 *  기본값 : EDPageFittingImageFull
 */
@property(nonatomic, assign) EDPageFittingStyle pageFittingStyle;
/**
 *  화면에 표시하는 페이지 갯수.
 *  양면 보기시에 2로 설정 합니다.
 *  기본값 : 1
 */
@property(nonatomic, assign) int displayPageCount;
/**
 *  displayPageCount가 2이상 일 경우 문서 첫 페이지 표시에서 빈 페이지 갯수.
 *  양면 보기시 표지 설정이 필요하다면 1로 설정 합니다.
 *  기본값 : 0
 */
@property(nonatomic, assign) int blankPageCount;
/**
 *  최대 확대 배율.
 *  기본값 : 256
 */
@property(nonatomic, assign) CGFloat maximumZoomScale;
/**
 *  화면 페이징 표시 여부
 *  끊김 없이 페이지를 표시하려면 NO설정 합니다.
 *  기본값 : NO
 */
@property(nonatomic, assign) BOOL pagingEnabled;
/**
 *  pagingEnabled이 NO일 때 페이지와 페이지 사이 간격.
 *  기본값 : 10
 */
@property(nonatomic, assign) CGFloat margin;
/**
 *  pagingEnabled이 YES일 때 페이지 이동에 필요한 드레그 크기.
 *  기본값 : 60
 */
@property(nonatomic, assign) CGFloat changePageDistance;
/**
 *  원활한 화면 표시를 위해 미리 준비하는 페이지 갯수.
 *  큰값을 설정할 경우 메모리 문제와 속도가 오히려 느려질 수 있습니다.
 *  기본값 : 2
 */
@property(nonatomic, assign) int reservePageCount;
/**
 *  최대 스크롤 크기
 *  문서가 최대 스크롤 크기를 넘는다면 충분한 값을 줘야 합니다.
 *  1000*1000 크기 페이지수가 10000이면 페이지 스크롤 크기는 100000000이어서 최대 스크롤 크기를 넘게 됩니다.
 *  기본값 : 9999999
 */
@property(nonatomic, assign) CGFloat maxScrollSize;
/**
 *  열람중에 화면을 탭하면 문서 보기 종료.
 *  잠시 열람하는 경우에만 YES를 주어서 바로 닫게 합니다.
 *  기본값 : NO
 */
@property(nonatomic, assign) BOOL isDismissOnTap;

/**
 *  문제풀이시 문제 영역을 클릭하면 정답 표시 여부.
 *  구현 필요.
 *  기본값 : NO
 */
@property(nonatomic, assign) BOOL checkOnClick;
/**
 *  자막 영역 강조 표시 색상.
 *  기본값 : RGBA(255, 255, 0, 64)
 */
@property(nonatomic, strong) UIColor *subtitleHighlightColor;
/**
 *  페이지 배경 색상
 *  기본값 : whiteColor
 */
@property(nonatomic, strong) UIColor *backgroundColor;

/**
 *  페이지 랜더링시 코어 그래픽 사용 여부.
 *  기본값 : YES
 */
@property(nonatomic, assign) BOOL xpdfPageRenderingWithCoreGraphic;
/**
 *  페이지 섬네일 파일 캐쉬 여부.
 *  기본값 : NO
 */
@property(nonatomic, assign) BOOL cachePageThumbnails;

/**
 *  하단 뷰어 설정.
 *  광고(Benner)와 같은 뷰를 설정 해야 할 때 사용합니다.
 *  기본값 : nil
 */
@property(nonatomic, strong) UIView<EDFooter> *footer;

/**
 *  기본 설정.
 *  @return 기본 설정
 */
+ (instancetype) defaultConfig;

@end

