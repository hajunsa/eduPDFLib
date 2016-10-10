//
//  EDDataProvider.h
//  eduPDFView
//
//  Created by puttana on 2016. 8. 9..
//  Copyright © 2016년 Unidocs. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  EDDataProvider.
 *  외부 DRM이나 데이터 변환이 필요한 경우에 사용합니다.
 *  기본로직은 일반 문서 파일 경로 열람과 동일합니다.
 *  상속 받아 DRM 걸린 문서에 대한 처리를 구현 해야합니다.
 */
@interface EDDataProvider : NSObject

/**
 *  생성자
 *
 *  @param path 문서 로컬 경로.
 */
- (instancetype) initWithPath:(NSString *)path;
/**
 *  문서 데이터 가져오기.
 *  외부 암호화 모듈을 사용시 블럭 단위 암호화 데이터를 복호화할 때 사용합니다.
 *  복화된 문서 바이너리를 buff에 넣어야 합니다.
 *
 *  @param buff 가져올 문서 데이터 버퍼.
 *  @param offset 가져올 문서 시작 오프셋.
 *  @param size 가져올 문서 데이터 크기.
 *  @return 읽어들인 데이터 크기.
 */
- (int) getBytes:(char *)buff offset:(unsigned int)offset size:(int)size;

/**
 *  파일 크기
 *  문서 크기 입니다.
 *
 *  @return 문서 크기.
 */
- (unsigned int) size;

/**
 *  문서 열기
 */
- (void) open;

/**
 *  문서 닫기
 */
- (void) close;

/**
 *  문서 로컬 경로.
 */
@property(nonatomic, strong) NSString *path;

@end
