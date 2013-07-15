//
//  DetailDownloadTableViewCustomCell.h
//  MyFlickr
//
//  Created by Jens Driller on 06/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailDownloadTableViewCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelPixels;

@end