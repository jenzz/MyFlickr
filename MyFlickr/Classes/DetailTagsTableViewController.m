//
//  DetailTagsTableViewController.m
//  MyFlickr
//
//  Created by Jens Driller on 04/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "DetailTagsTableViewController.h"
#import "DetailTabBarController.h"
#import "FlickrPicture.h"
#import "DetailTagsTableViewCustomCell.h"
#import "DetailWebViewController.h"
#import "StartViewController.h"
#import "Constants.h"

@implementation DetailTagsTableViewController


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

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    
}





/* ***************************************************** */
/*                                                       */
/*                 TABLE VIEW DATASOURCE                 */
/*                                                       */
/* ***************************************************** */
#pragma mark - TableView Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       
    if(detailTabBarController.flickrPicture.tags.count == 0) {
        return 1;
    } else {
        return detailTabBarController.flickrPicture.tags.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
              
    DetailTagsTableViewCustomCell *cell;
    
    if(detailTabBarController.flickrPicture.tags.count == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"noTagsCell"];
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"tagCell"];
        cell.labelTitle.text = [detailTabBarController.flickrPicture.tags objectAtIndex:indexPath.row];
        
    }
    
    return cell;
    
}





/* ***************************************************** */
/*                                                       */
/*                 TABLE VIEW DATASOURCE                 */
/*                                                       */
/* ***************************************************** */
#pragma mark - TableView Datasource


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:(UITableViewCell *) [(UIView *) [sender superview]superview]];
    NSString *selectedTag = [detailTabBarController.flickrPicture.tags objectAtIndex:selectedIndexPath.row];
    
    DetailWebViewController *detailWebViewController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"googleSearch"]) {    
        
        NSString *urlString = [[NSString stringWithFormat:GOOGLE_SEARCH_URL, selectedTag] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        detailWebViewController.urlToLoad = [NSURL URLWithString:urlString];
        
    } else if([segue.identifier isEqualToString:@"wikipediaSearch"]) {
        
        NSString *urlString = [[NSString stringWithFormat:WIKIPEDIA_SEARCH_URL, selectedTag] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        detailWebViewController.urlToLoad = [NSURL URLWithString:urlString];
        
    }
    
}





/* ***************************************************** */
/*                                                       */
/*                       IBACTIONS                       */
/*                                                       */
/* ***************************************************** */
#pragma mark - IBActions


- (IBAction)buttonSearchClicked:(id)sender {
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:(UITableViewCell *) [(UIView *) [sender superview]superview]];
    NSString *selectedTag = [detailTabBarController.flickrPicture.tags objectAtIndex:selectedIndexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tagSearch" object:selectedTag];
    [self.navigationController popViewControllerAnimated:YES];
    
} 

@end