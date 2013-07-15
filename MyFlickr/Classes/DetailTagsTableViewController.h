//
//  DetailTagsTableViewController.h
//  MyFlickr
//
//  Created by Jens Driller on 04/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailTabBarController;

@interface DetailTagsTableViewController : UITableViewController {
    
    DetailTabBarController *detailTabBarController;
    
}

- (IBAction)buttonSearchClicked:(id)sender;

@end