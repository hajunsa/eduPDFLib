//
//  TouchInputView.m
//  Audio
//
//  Created by puttana on 2017. 1. 12..
//  Copyright © 2017년 Unidocs Inc. All rights reserved.
//

#import "TouchInputView.h"
#import <eduPDFPlayerS/eduPDFPlayer.h>

@implementation TouchInputView
{
    CGPoint _startPoint;
    CGPoint _lastPoint;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.exclusiveTouch = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    _startPoint = pt;
    _lastPoint = _startPoint;

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    _lastPoint = pt;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    float deltaX = _startPoint.x - _lastPoint.x;
    float deltaY = _startPoint.y - _lastPoint.y;
    
    CGFloat dis = sqrtf((deltaX * deltaX) + (deltaY * deltaY));
    if (dis < 1.0) {  // One Tap
        UITouch *touch = [touches anyObject];
        EDTouchCoordination *coord = [self.player doSingleTapAction:touch];
        if (coord.type == EDTouchAnnotation) {  // 주석 객체가 액션(재생)을 한 경우
            NSLog(@"Annotation type=%@ Play", coord.annotation.type);
        }
    }
}
@end
