//
//  TableViewController.m
//  TableViewMap
//
//  Created by David Jangdal on 2016-05-24.
//  Copyright © 2016 DavidJangdal. All rights reserved.
//

#import "TableViewController.h"
#import "InfoTableViewCell.h"
#import "MapTableViewCell.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource, MapTableViewCellDelegate>

@property (nonatomic) NSMutableArray *rows;

@end

static NSString * const InfoTableViewCellIdentifier = @"InfoTableViewCellIdentifier";
static NSString * const MapTableViewCellIdentifier = @"MapTableViewCellIdentifier";

static CGFloat const InfoTableViewCellHeight = 80;
static CGFloat const MapTableViewCellHeight = 200;

@implementation TableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.tableView registerClass:[InfoTableViewCell class] forCellReuseIdentifier:InfoTableViewCellIdentifier];
        [self.tableView registerClass:[MapTableViewCell class] forCellReuseIdentifier:MapTableViewCellIdentifier];
        
        self.rows = [NSMutableArray new];
        
        for (int i=0; i<40; i++) {
            UIImage *icon = [self imageWithColor:[self randomColor]];
            InfoTableViewCellModel *infoTableViewCellModel = [[InfoTableViewCellModel alloc] initWithTitle:@"Some title" andIcon:icon];
            infoTableViewCellModel.cellHeight = InfoTableViewCellHeight;
            [self.rows addObject:infoTableViewCellModel];
            
            if (i%4==0) {
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake(arc4random() % 50, arc4random() % 50);
                MapTableViewCellModel *mapTableViewCellModel = [[MapTableViewCellModel alloc] initWithLocation:location];
                mapTableViewCellModel.cellHeight = MapTableViewCellHeight;
                [self.rows addObject:mapTableViewCellModel];
            }
        }
    }
    return self;
}

#define ARC4RANDOM_MAX      0x100000000
- (UIColor *)randomColor {
    CGFloat red = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat green = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat blue = ((double)arc4random() / ARC4RANDOM_MAX);
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGSize size = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *object = [self.rows objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[InfoTableViewCellModel class]]) {
        InfoTableViewCellModel *cellModel = (InfoTableViewCellModel *)object;
        return cellModel.cellHeight;
    }
    else if ([object isKindOfClass:[MapTableViewCellModel class]]) {
        MapTableViewCellModel *cellModel = (MapTableViewCellModel *)object;
        return cellModel.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *object = [self.rows objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[InfoTableViewCellModel class]]) {
        InfoTableViewCellModel *cellModel = (InfoTableViewCellModel *)object;
        InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoTableViewCellIdentifier forIndexPath:indexPath];
        cell.cellModel = cellModel;
        return cell;
    }
    else if ([object isKindOfClass:[MapTableViewCellModel class]]) {
        MapTableViewCellModel *cellModel = (MapTableViewCellModel *)object;
        MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MapTableViewCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.cellModel = cellModel;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *object = [self.rows objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[MapTableViewCellModel class]]) {
        MapTableViewCellModel *cellModel = (MapTableViewCellModel *)object;
        if (cellModel.cellHeight != self.tableView.frame.size.height) {
            MapTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell didTapMapView];
            self.tableView.scrollEnabled = NO;
            [self.tableView beginUpdates];
            cellModel.cellHeight = self.tableView.frame.size.height;
            [self.tableView endUpdates];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)MapTableViewCellDidTapCloseButton:(MapTableViewCell *)mapTableViewCell {
    self.tableView.scrollEnabled = YES;
    [self.tableView beginUpdates];
    mapTableViewCell.cellModel.cellHeight = MapTableViewCellHeight;
    [self.tableView endUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.rows indexOfObject:mapTableViewCell.cellModel] inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


@end
