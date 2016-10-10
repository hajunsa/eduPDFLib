//
//  EDHTTPConfig.h
//  eduPDFView
//
//  Created by 허기수 on 2016. 7. 6..
//  Copyright © 2016년 Unidocs. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  문서 페이지 관련 설정.
 */
@interface EDHTTPConfig : NSObject

/**
 *  Fast Open시 전체 캐쉬 크기.
 *  기본값 : 16*1024*1024 bytes
 */
@property (nonatomic, assign) int64_t fastOpenTotalCacheSize;
/**
 *  Fast Open 비활성화.
 *  기본값 : NO
 */
@property (nonatomic, assign) BOOL disableFastOpen;
/**
 *  원격 경로는 모두 PDF 형식으로 설정.
 *  기본값 : YES
 */
@property (nonatomic, assign) BOOL onlyContentsTypePDF;
/**
 *  파일 다운로드 비활성화.
 *  기본값 : NO
 */
@property (nonatomic, assign) BOOL disableDownload;
/**
 *  HTTPS 통신시 인증된 서명만 사용할지 여부.
 *  기본값 : NO
 */
@property (nonatomic, assign) BOOL validatesSecureCertificateHTTPS;
/**
 *  원격경로 문서 로컬 파일 저장 여부.
 *  기본값 : NO
 */
@property (nonatomic, assign) BOOL disableFileSave;
/**
 *  원격경로 빠른 다운로드 사용 여부.
 *  정적 파일을 다운로드할 때 느린 WAS(톰캣 같은)대신 아파치를 이용한 다운로드가 필요한 경우에 사용합니다.
 *  WAS와 프로토콜 정의가 필요합니다.
 *  기본값 : NO
 */
@property (nonatomic, assign) BOOL enableFastDownload;
/**
 *  다운로드 경로.
 *  기본값 : Library/Caches/Download
 */
@property (nonatomic, strong) NSString *downloadDir;

/**
 *  기본 설정
 *  @return 기본 설정
 */
+ (instancetype)defaultConfig;

@end
