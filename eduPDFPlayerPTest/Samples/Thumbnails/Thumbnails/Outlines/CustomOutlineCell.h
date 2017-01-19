//
//  CustomOutlineCell.h
//  ezPDFViewLibrarySample
//
//  Created by 허기수 on 2015. 9. 14..
//  Copyright (c) 2015년 Unidocs Inc. All rights reserved.
//

#import <eduPDFPlayerS/eduPDFPlayer.h>

@interface CustomFolderButton : UIButton

@property (nonatomic, assign) NSInteger row;

@end

@interface CustomOutlineCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet CustomFolderButton *push;
@property (nonatomic, weak) IBOutlet UIView *containView;

@end
