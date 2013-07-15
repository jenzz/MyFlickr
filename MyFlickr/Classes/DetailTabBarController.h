//
//  DetailTabBarController.h
//  MyFlickr
//
//  Created by Jens Driller on 03/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class FlickrPicture;

@interface DetailTabBarController : UITabBarController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) FlickrPicture *flickrPicture;

- (IBAction) sharePicture;
- (void) showDelayedAlert:(UIAlertView *)alert;

@end