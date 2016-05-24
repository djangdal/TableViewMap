//
//  MapTableViewCell.m
//  TableViewMap
//
//  Created by David Jangdal on 2016-05-24.
//  Copyright © 2016 DavidJangdal. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCellModel

- (instancetype)initWithLocation:(CLLocationCoordinate2D)annotationLocation {
    self = [super init];
    if (self) {
        _annotationLocation = annotationLocation;
    }
    return self;
}

@end

@interface MapTableViewCell () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLPointAnnotation *locationAnnotation;
@property (nonatomic) UIButton *closeButton;

@end

@implementation MapTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.mapView = [[MGLMapView alloc] initWithFrame:self.frame];
        self.mapView.delegate = self;
        self.mapView.zoomEnabled = NO;
        self.mapView.scrollEnabled = NO;
        self.mapView.userInteractionEnabled = NO;
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton addTarget:self action:@selector(didTapCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.closeButton setTitle:@"X" forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        self.closeButton.backgroundColor = [UIColor whiteColor];
        self.closeButton.layer.cornerRadius = 5;
        
        [self addSubview:self.mapView];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mapView.frame = [UIScreen mainScreen].bounds;
    self.mapView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)prepareForReuse {
    [self.mapView removeAnnotation:self.locationAnnotation];
    self.locationAnnotation = nil;
    [self setNeedsLayout];
}

- (void)setCellModel:(MapTableViewCellModel *)cellModel {
    _cellModel = cellModel;
    self.locationAnnotation = [[MGLPointAnnotation alloc] init];
    self.locationAnnotation.coordinate = cellModel.annotationLocation;
    [self.mapView addAnnotation:self.locationAnnotation];
    
    [self centerOnAnnotation];
    
    [self setNeedsLayout];
}

- (void)centerOnAnnotation {
    [self.mapView setCenterCoordinate:self.locationAnnotation.coordinate zoomLevel:5 animated:YES];
}

- (void)didTapMapView {
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.userInteractionEnabled = YES;
    
    self.closeButton.frame = CGRectMake(10, -40, 40, 40);
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
        self.closeButton.frame = CGRectMake(10, 30, 40, 40);
    } completion:nil];
}

- (void)didTapCloseButton {
    self.mapView.zoomEnabled = NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.userInteractionEnabled = NO;
    self.closeButton.frame = CGRectMake(10, 30, 40, 40);
    [self centerOnAnnotation];
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
        self.closeButton.frame = CGRectMake(10, -40, 40, 40);
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(MapTableViewCellDidTapCloseButton:)]) {
        [self.delegate MapTableViewCellDidTapCloseButton:self];
    }
}

@end
