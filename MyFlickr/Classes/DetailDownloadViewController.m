//
//  DetailDownloadViewController.m
//  MyFlickr
//
//  Created by Jens Driller on 05/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "DetailDownloadViewController.h"
#import "DetailTabBarController.h"
#import "FlickrPicture.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "SDNetworkActivityIndicator.h"
#import "DetailDownloadTableViewCustomCell.h"

@implementation DetailDownloadViewController

@synthesize thumbnailImage, labelTitle, labelOwner, labelDownloading;


/* ***************************************************** */
/*                                                       */
/*                VIEW CONTROLLER METHODS                */
/*                                                       */
/* ***************************************************** */
#pragma mark - View Controller Methods


- (void)viewDidLoad {
    
    if(detailTabBarController == nil) {
        detailTabBarController = (DetailTabBarController *) self.tabBarController;
    }
    
    sizeLabels = [NSArray arrayWithObjects:@"Thumbnail", @"Small", @"Medium", @"Large", @"Original", nil];
    sizePixels = [NSArray arrayWithObjects:@"75x75", @"240x160", @"550x335", @"1024x768", @"~", nil];
    
    self.labelTitle.text = detailTabBarController.flickrPicture.title;
    self.labelOwner.text = detailTabBarController.flickrPicture.ownerName;
    [self.thumbnailImage setImageWithURL:detailTabBarController.flickrPicture.urlThumbnail placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
}


- (void)viewDidUnload {
    
    [self setThumbnailImage:nil];
    [self setLabelTitle:nil];
    [self setLabelOwner:nil];
    [self setLabelDownloading:nil];
    [super viewDidUnload];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return interfaceOrientation == UIInterfaceOrientationPortrait ||
    interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
    
}





/* ***************************************************** */
/*                                                       */
/*                       IBACTIONS                       */
/*                                                       */
/* ***************************************************** */
#pragma mark - IBActions


- (IBAction)downloadButtonClicked {
    
    NSString *selectedSize = [sizeLabels objectAtIndex:lastIndexPath.row];
    
    NSURL *downloadURL = [[NSURL alloc] init];
    
    if([selectedSize isEqualToString:@"Thumbnail"]) {        
        downloadURL = detailTabBarController.flickrPicture.urlThumbnail;
    } else if([selectedSize isEqualToString:@"Small"]) {
        downloadURL = detailTabBarController.flickrPicture.urlSmall;
    } else if([selectedSize isEqualToString:@"Medium"]) {
        downloadURL = detailTabBarController.flickrPicture.urlMedium;
    } else if([selectedSize isEqualToString:@"Large"]) {
        downloadURL = detailTabBarController.flickrPicture.urlLarge;
    } else if([selectedSize isEqualToString:@"Original"]) {
        downloadURL = detailTabBarController.flickrPicture.urlOriginal;
    }
    
    downloader = [SDWebImageDownloader downloaderWithURL:downloadURL delegate:self];
    self.labelDownloading.alpha = 1.0f;
    
}





/* ***************************************************** */
/*                                                       */
/*               IMAGE DOWNLOADER DELEGATE               */
/*                                                       */
/* ***************************************************** */
#pragma mark - Image Downloader Delegate


- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image {
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}


- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error {
    
    self.labelDownloading.alpha = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be downloaded" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    self.labelDownloading.alpha = 0;
    
    if(error != NULL) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image saved" message:@"Image successfully saved. Check your photo album." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}





/* ***************************************************** */
/*                                                       */
/*                 TABLE VIEW DATASOURCE                 */
/*                                                       */
/* ***************************************************** */
#pragma mark - Table View Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return sizeLabels.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
    DetailDownloadTableViewCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sizeCell"];
    cell.labelTitle.text = [sizeLabels objectAtIndex:indexPath.row];
    cell.labelPixels.text = [sizePixels objectAtIndex:indexPath.row];
    
    FlickrPicture *pic = detailTabBarController.flickrPicture;
    
    // Disable cell when the size is not available for download
    if( ([cell.labelTitle.text isEqualToString:@"Thumbnail"] && pic.urlThumbnail == NULL) ||
        ([cell.labelTitle.text isEqualToString:@"Small"]     && pic.urlSmall == NULL)     ||
        ([cell.labelTitle.text isEqualToString:@"Medium"]    && pic.urlMedium == NULL)    ||
        ([cell.labelTitle.text isEqualToString:@"Large"]     && pic.urlLarge == NULL)     ||
        ([cell.labelTitle.text isEqualToString:@"Original"]  && pic.urlOriginal == NULL) ) {
        
            cell.userInteractionEnabled = NO;
            cell.labelTitle.enabled = NO;
            cell.labelPixels.enabled = NO;
 
    }
    
    // Preselect medium size
    if([cell.labelTitle.text isEqualToString:@"Medium"]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        lastIndexPath = indexPath;
        
    }
    
    return cell;
        
}





/* ***************************************************** */
/*                                                       */
/*                  TABLE VIEW DELEGATE                  */
/*                                                       */
/* ***************************************************** */
#pragma mark - Table View Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       
    if (indexPath.row != lastIndexPath.row) {
        
        DetailDownloadTableViewCustomCell *newCell = (DetailDownloadTableViewCustomCell *) [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        DetailDownloadTableViewCustomCell *oldCell = (DetailDownloadTableViewCustomCell *) [tableView cellForRowAtIndexPath:lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        lastIndexPath = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end