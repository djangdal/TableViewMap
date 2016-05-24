//
//  InfoTableViewCell.h
//  TableViewMap
//
//  Created by David Jangdal on 2016-05-24.
//  Copyright © 2016 DavidJangdal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCellModel : NSObject

- (instancetype)initWithTitle:(NSString *)title andIcon:(UIImage *)icon;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic) CGFloat cellHeight;

@end

@interface InfoTableViewCell : UITableViewCell

@property (nonatomic) InfoTableViewCellModel *cellModel;

@end
