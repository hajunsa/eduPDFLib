//
//  PrintPageRenderer.h
//
//
//  Created by Unidocs Mac on 2017. 2. 13..
//  Copyright © 2017년 Unidocs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class eduPDFPlayer;

@interface MyPrintPageRenderer : UIPrintPageRenderer

@property(nonatomic, strong) eduPDFPlayer *player;

@end
