//
//  DetailPictureViewController.h
//  MyFlickr
//
//  Created by Jens Driller on 03/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailTabBarController;

@interface DetailPictureViewController : UIViewController {
    
    DetailTabBarController *detailTabBarController;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelOwner;
@property (strong, nonatomic) IBOutlet UITextView *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelViews;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;

@end