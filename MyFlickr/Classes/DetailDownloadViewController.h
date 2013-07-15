//
//  DetailDownloadViewController.h
//  MyFlickr
//
//  Created by Jens Driller on 05/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloaderDelegate.h"

@class DetailTabBarController, SDWebImageDownloader;

@interface DetailDownloadViewController : UIViewController <SDWebImageDownloaderDelegate> {
    
    DetailTabBarController *detailTabBarController;
    SDWebImageDownloader *downloader;
    NSArray *sizeLabels;
    NSArray *sizePixels;
    NSIndexPath *lastIndexPath;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelOwner;
@property (strong, nonatomic) IBOutlet UILabel *labelDownloading;

- (IBAction)downloadButtonClicked;

@end