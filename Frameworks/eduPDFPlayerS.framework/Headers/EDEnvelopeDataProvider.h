//
//  EDEnvelopeDataProvider
//  eduPDFView
//
//  Created by 허기수 on 2016. 8. 10..
//  Copyright © 2016년 Unidocs. All rights reserved.
//

#import "EDDataProvider.h"

/**
 *  EDEnvelopeDataProvider.
 *  Unidocs DRM4 문서 열람시 사용합니다.
 */
@interface EDEnvelopeDataProvider : EDDataProvider

/**
 *  문서 열람 키.
 */
@property(nonatomic, strong) NSString *openKey;

@end
