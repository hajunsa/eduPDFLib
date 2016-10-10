//
//  EDFooter.h
//  eduPDFView
//
//  Created by 허기수 on 2016. 8. 17..
//  Copyright © 2016년 Unidocs. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  컨텐츠 마지막 페이지에 들어가는 하단바.
 *  마지막 페이지 번호를 가집니다.
 */
@protocol EDFooter <NSObject>

@required
/**
 *  Footer 세로 길이
 *
 *  @param width Footer 가로 길이(이전 페이지 가로길이와 동일).
 *  @return 세로 길이.
 */
- (CGFloat)heightWithWidth:(CGFloat)width;

/**
 *  화면에 그리기.
 */
- (void)display;

@end
