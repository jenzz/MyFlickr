//
//  DetailCommentsTableViewCustomCell.h
//  MyFlickr
//
//  Created by Jens Driller on 05/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCommentsTableViewCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *authorImage;
@property (strong, nonatomic) IBOutlet UILabel *authorName;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITextView *comment;

@end