//
//  DetailFullscreenViewController.h
//  MyFlickr
//
//  Created by Jens Driller on 01/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailTabBarController;

@interface DetailFullscreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSURL *urlMedium;

- (IBAction)handleTap:(id)sender;
- (IBAction)handleRotation:(id)sender;

@end