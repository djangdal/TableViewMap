//
//  InfoTableViewCell.m
//  TableViewMap
//
//  Created by David Jangdal on 2016-05-24.
//  Copyright © 2016 DavidJangdal. All rights reserved.
//

#import "InfoTableViewCell.h"

@implementation InfoTableViewCellModel

- (instancetype)initWithTitle:(NSString *)title andIcon:(UIImage *)icon {
    self = [super init];
    if (self) {
        _title = title;
        _icon = icon;
    }
    return self;
}

@end

@interface InfoTableViewCell ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *iconImageView;

@end

@implementation InfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [UILabel new];
        self.iconImageView = [UIImageView new];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat iconSize = self.frame.size.height-20;
    self.iconImageView.frame = CGRectMake(10, 10, iconSize, iconSize);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(CGRectGetMaxX(self.iconImageView.frame) + 10 + self.titleLabel.frame.size.width / 2,
                                         self.frame.size.height / 2);
}

- (void)prepareForReuse {
    self.titleLabel.text = @"";
    self.iconImageView.image = nil;
    [self setNeedsLayout];
}

- (void)setCellModel:(InfoTableViewCellModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    self.iconImageView.image = cellModel.icon;
    
    [self setNeedsLayout];
}

@end
