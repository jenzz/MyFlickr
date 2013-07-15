//
//  StartViewControllerCustomTableCell.h
//  MyFlickr
//
//  Created by Jens Driller on 04/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewControllerCustomTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelOwner;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end