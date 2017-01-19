//
//  CustomOutlines.h
//  ezPDFViewLibrarySample
//
//  Created by 허기수 on 2015. 9. 14..
//  Copyright (c) 2015년 Unidocs Inc. All rights reserved.
//

#import <eduPDFPlayerS/eduPDFPlayer.h>

@interface CustomOutlines : UITableViewController <UINavigationBarDelegate>

@property(nonatomic, strong) EDOutlines *outlines;

@property(nonatomic, weak) eduPDFPlayer *player;

@property(nonatomic, assign) BOOL pushed;

@end
