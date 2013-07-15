//
//  DetailPictureViewController.m
//  MyFlickr
//
//  Created by Jens Driller on 03/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "DetailPictureViewController.h"
#import "DetailTabBarController.h"
#import "DetailFullscreenViewController.h"
#import "FlickrPicture.h"
#import "UIImageView+WebCache.h"
#import "SDNetworkActivityIndicator.h"

@implementation DetailPictureViewController

@synthesize imageView, labelTitle, labelOwner, labelDescription, labelViews, labelDate;


/* ***************************************************** */
/*                                                       */
/*                VIEW CONTROLLER METHODS                */
/*                                                       */
/* ***************************************************** */
#pragma mark - View Controller Methods


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(detailTabBarController == nil) {
        detailTabBarController = (DetailTabBarController *) self.tabBarController;
    }
    
    if(detailTabBarController.flickrPicture) {
        
        [self.imageView setImageWithURL:detailTabBarController.flickrPicture.urlSmall placeholderImage:[UIImage imageNamed:@"placeholder_detail.png"]];
        self.labelTitle.text = detailTabBarController.flickrPicture.title;
        self.labelOwner.text = detailTabBarController.flickrPicture.ownerName;
        self.labelDescription.text = [detailTabBarController.flickrPicture.description isEqualToString:@""] ? @"- no description -" : detailTabBarController.flickrPicture.description;
        self.labelViews.text = [detailTabBarController.flickrPicture.views stringValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, dd MMMM yyyy - HH:mm:ss"];
        self.labelDate.text = [dateFormatter stringFromDate:detailTabBarController.flickrPicture.dateTaken];
        
    }
    
}


- (void)viewDidAppear:(BOOL)animated {
    
    // Flash scrollbar once if scrolling is available
    [self.labelDescription flashScrollIndicators];
    
}


- (void)viewDidUnload {
    
    [self setLabelViews:nil];
    [self setLabelDate:nil];
    [super viewDidUnload];
    [self setLabelTitle:nil];
    [self setLabelDescription:nil];
    [self setLabelOwner:nil];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return interfaceOrientation == UIInterfaceOrientationPortrait ||
           interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
    
}





/* ***************************************************** */
/*                                                       */
/*                FULLSCREEN PREPARATION                 */
/*                                                       */
/* ***************************************************** */
#pragma mark - Fullscreen Preparation


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if(detailTabBarController.flickrPicture) {
        
        DetailFullscreenViewController *detailFullscreenViewController = segue.destinationViewController;
        
        if([segue.identifier isEqualToString:@"showFullscreen"]) {
            
            detailFullscreenViewController.urlMedium = detailTabBarController.flickrPicture.urlMedium;
            
        }
        
    }
    
}

@end