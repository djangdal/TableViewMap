//
//  MapTableViewCell.h
//  TableViewMap
//
//  Created by David Jangdal on 2016-05-24.
//  Copyright © 2016 DavidJangdal. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Mapbox;

@class MapTableViewCell;
@protocol MapTableViewCellDelegate <NSObject>

- (void)MapTableViewCellDidTapCloseButton:(MapTableViewCell *)mapTableViewCell;

@end

@interface MapTableViewCellModel : NSObject

- (instancetype)initWithLocation:(CLLocationCoordinate2D)annotationLocation;

@property (nonatomic, readonly) CLLocationCoordinate2D annotationLocation;
@property (nonatomic) CGFloat cellHeight;

@end

@interface MapTableViewCell : UITableViewCell

@property (nonatomic) MapTableViewCellModel *cellModel;
@property (nonatomic, weak) id <MapTableViewCellDelegate> delegate;

- (void)didTapMapView;

@end
