//
//  StartViewController.h
//  MyFlickr
//
//  Created by Jens Driller on 28/11/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPicture;

@interface StartViewController : UIViewController {
    
    NSURLConnection *flickrConnection;
    NSMutableData *jsonData;
    BOOL viewAppearsFirstTime;
    
}

@property (strong, nonatomic) NSMutableArray *flickrPictures;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *labelTotalNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelPageNumber;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonPreviousPage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonNextPage;

// The saved states of the searchbar if e.g. a memory warning removed the view
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (IBAction) buttonPreviousPageClicked;
- (IBAction) buttonNextPageClicked;
- (void) loadRecentPictures;
- (void) searchFlickrPictures:(NSString *)text;
- (void) showAlert:(NSString *)text;
- (void) performFlickrRequest:(NSURL *)url;

@end