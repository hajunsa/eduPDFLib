//
//  PrintPageRenderer.m
//  
//
//  Created by Unidocs Mac on 2017. 2. 13..
//  Copyright © 2017년 Unidocs. All rights reserved.
//

#import "MyPrintPageRenderer.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>

@implementation MyPrintPageRenderer

- (NSInteger) numberOfPages{
    return [self.player pageCount];
}

- (void)prepareForDrawingPages:(NSRange)range{
    // override point. default does nothing. called before requesting a set of pages to draw
}

- (void)drawPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)printableRect{
    // override point. may be called from non-main thread.  calls the various draw methods below.
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.player renderPage:context pageNo:(int)pageIndex+1 bounds:printableRect];
    
}
- (void)drawPrintFormatter:(UIPrintFormatter *)printFormatter forPageAtIndex:(NSInteger)pageIndex{
    // override point. calls each formatter to draw for that page. subclassers must call super.
}
- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex  inRect:(CGRect)headerRect{
    // override point. default does nothing
}
- (void)drawContentForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)contentRect{
    // override point. default does nothing
}
- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex  inRect:(CGRect)footerRect{
    // override point. default does nothing
}


@end
