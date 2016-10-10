//
//  EDPageEnums.h
//  eduPDFView
//
//  Created by 허기수 on 2016. 5. 26..
//  Copyright © 2016년 Unidocs. All rights reserved.
//

/**
 문서 열람시 성공 또는 실패 종류.
 */
typedef NS_ENUM(NSInteger, eduPDFOpenFinishedType) {
    /**
     *  문서 열람 성공.
     */
    eduPDFOpen_Success,
    /**
     *  존재하지 않거나 형식이 유효하지 않은 경로.
     */
    eduPDFOpen_InvailedPath,
    /**
     *  문서 형식이 명시한 형식과 일치 하지 않을 때.
     */
    eduPDFOpen_InvailedFormat,
    /**
     *  DRM이 걸리 문서를 유효하지 않는 방법으로 열려고 할 때.
     */
    eduPDFOpen_InvailedDRM,
    /**
     *  문서 열람 패스워드가 틀릴 때.
     */
    eduPDFOpen_InvailedPassword,
    /**
     *  문서 열람시 패스워드 입력이 필요 할 때.
     */
    eduPDFOpen_RequiredPassword,
    /**
     *  네트웍 연결이 필요한 문서 열람시 연결에 문제가 있을 때.
     */
    eduPDFOpen_InvailedNetwork,
    /**
     *  라이센스 코드가 유효하지 않을 때.
     */
    eduPDFOpen_InvailedLicenseCode,
    /**
     *  알수 없는 오류가 났을 때.
     */
    eduPDFOpen_Unknown
};

/**
 페이지 이동시 성공 또는 실패 종류.
 */
typedef NS_ENUM(NSInteger, EDPageMoveFinishedType) {
    /**
     *  페이지 이동 성공.
     */
    EDPageMove_Success,
    /**
     *  페이지 번호가 유효하지 않음.
     */
    EDPageMove_InvailedPageNo,
    /**
     *  페이지 뷰어가 존재하지 않음.
     */
    EDPageMove_NotExistsPageView,
};


/**
 *  문서 읽기 방향 설정
 */
typedef NS_ENUM(NSInteger, EDPageReadDirectionStyle) {
    /**
     *  문서에서 정의한 방향.
     */
    EDPageReadDirectionAuto,
    /**
     * 문서를 왼쪽으로 읽음.
     */
    EDPageReadDirectionRight,
    /**
     * 문서를 오른쪽으로 읽음.
     */
    EDPageReadDirectionLeft
};

/**
 *  문서 스크롤 방향 설정
 */
typedef NS_ENUM(NSInteger, EDPageScrollDirectionStyle) {
    /**
     *  문서를 가로로 스크롤.
     */
    EDPageScrollDirectionHorizontal,
    /**
     *  문서를 세로로 스크롤.
     */
    EDPageScrollDirectionVertical
};

/**
 *  문서 페이지 화면 피팅 스타일
 */
typedef NS_ENUM(NSInteger, EDPageFittingStyle) {
    /**
     *  페이지 전체가 화면에 표시
     */
    EDPageFittingImageFull,
    /**
     *  화면 전체에 페이지 일부가 가득 표시
     */
    EDPageFittingDisplayFull,
    /**
     *  페이지가 화면 가로 길이에 가득 표시
     */
    EDPageFittingWidth,
    /**
     *  페이지가 화면 세로 길이에 가득 표시
     */
    EDPageFittingHeight,
    /**
     *  자동 피팅, 구현 안됨.
     */
    EDPageFittingAuto
};