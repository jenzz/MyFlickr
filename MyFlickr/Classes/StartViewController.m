//
//  StartViewController.m
//  MyFlickr
//
//  Created by Jens Driller on 28/11/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "StartViewController.h"
#import "StartViewControllerCustomTableCell.h"
#import "Constants.h"
#import "DetailTabBarController.h"
#import "FlickrPicture.h"
#import "UIImageView+WebCache.h"
#import "SDNetworkActivityIndicator.h"

@implementation StartViewController

@synthesize tableView, searchBar, flickrPictures, labelTotalNumber, labelPageNumber, bottomToolBar, buttonPreviousPage, buttonNextPage, savedSearchTerm, savedScopeButtonIndex, searchWasActive;
static int currentPage;


/* ***************************************************** */
/*                                                       */
/*                       BUILD URLS                      */
/*                                                       */
/* ***************************************************** */
#pragma mark - Build URLs


- (void) loadRecentPictures {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=%@&per_page=%i&page=%i&format=json&nojsoncallback=1&extras=url_s,url_sq,url_m,url_l,url_o,description,date_taken,owner_name,tags,geo,views", FLICKR_API_KEY, PICS_PER_PAGE, currentPage];  
    
    [self performFlickrRequest:[NSURL URLWithString:urlString]];
    
}


- (void) searchFlickrPictures:(NSString *)text {
    
    NSString *searchScope = self.searchBar.selectedScopeButtonIndex == 1 ? @"tags" : @"text";
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&%@=%@&per_page=%i&page=%i&format=json&nojsoncallback=1&extras=url_s,url_sq,url_m,description,date_taken,owner_name,tags,geo,views", FLICKR_API_KEY, searchScope, [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], PICS_PER_PAGE, currentPage];  
    
    [self performFlickrRequest:[NSURL URLWithString:urlString]];
    
}





/* ***************************************************** */
/*                                                       */
/*                   FLICKR URL REQUEST                  */
/*                                                       */
/* ***************************************************** */
#pragma mark -  Flickr URL Request


- (void) performFlickrRequest:(NSURL *)url {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    if(flickrConnection) {
        [flickrConnection cancel];
        flickrConnection = nil;
    }
    flickrConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
       
    if(self.flickrPictures == nil) {
        self.flickrPictures = [[NSMutableArray alloc] init];
    }
    
    if(jsonData == nil) {
        jsonData = [[NSMutableData alloc]init];
    }
    
    // Remove any data from a previous search
    jsonData.length = 0;
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {  
    
    [jsonData appendData:data];
    
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // Create a dictionary from the JSON string
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    NSDictionary *metaData = [results objectForKey:@"photos"];
    NSString* pageNumber = [NSString stringWithFormat:@"%@", [metaData objectForKey:@"page"]];
    NSString* pages = [NSString stringWithFormat:@"%@", [metaData objectForKey:@"pages"]];
    NSString* total = [NSString stringWithFormat:@"%@", [metaData objectForKey:@"total"]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *totalNum = [numberFormatter numberFromString:total];
    NSNumber *pageNumberNum = [numberFormatter numberFromString:pageNumber];
    NSNumber *pagesNum = [numberFormatter numberFromString:pages];

    // If pictures found
    if(![totalNum isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        [self.flickrPictures removeAllObjects];
        
        if([pageNumberNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
            self.buttonPreviousPage.enabled = NO;
        } else {
            self.buttonPreviousPage.enabled = YES;
        }
        
        if([pageNumberNum isEqualToNumber:pagesNum]) {
            self.buttonNextPage.enabled = NO;
        } else {
            self.buttonNextPage.enabled = YES;
        }

        if(viewAppearsFirstTime) {
            self.labelTotalNumber.text = [NSString stringWithFormat:@"%@ latest photos loaded", [numberFormatter stringFromNumber:totalNum]];
        } else {
            self.labelTotalNumber.text = [NSString stringWithFormat:@"%@ pictures found", [numberFormatter stringFromNumber:totalNum]];
        }
        
        self.labelPageNumber.text = [NSString stringWithFormat:@"Page %@/%@",  [numberFormatter stringFromNumber:pageNumberNum], [numberFormatter stringFromNumber:pagesNum]];   
        
        // Iterate over all found pictures  
        NSArray *photos = [metaData objectForKey:@"photo"];
        for (NSDictionary *photo in photos) {
            
            NSString *idNumber = [NSString stringWithFormat:@"%@", [photo objectForKey:@"id"]];
            NSString *title = [NSString stringWithFormat:@"%@", [photo objectForKey:@"title"]];
            NSString *description = [NSString stringWithFormat:@"%@", [[photo objectForKey:@"description"] objectForKey:@"_content"]];
            NSString *dateTaken = [NSString stringWithFormat:@"%@", [photo objectForKey:@"datetaken"]];
            NSString *ownerName = [NSString stringWithFormat:@"%@", [photo objectForKey:@"ownername"]];
            NSString *tags = [NSString stringWithFormat:@"%@", [photo objectForKey:@"tags"]];     
            NSString *views = [NSString stringWithFormat:@"%@", [photo objectForKey:@"views"]];
            NSString *urlThumbnail = [NSString stringWithFormat:@"%@", [photo objectForKey:@"url_sq"]];
            NSString *urlSmall = [NSString stringWithFormat:@"%@", [photo objectForKey:@"url_s"]];
            NSString *urlMedium = [NSString stringWithFormat:@"%@", [photo objectForKey:@"url_m"]];
            NSString *urlLarge = [NSString stringWithFormat:@"%@", [photo objectForKey:@"url_l"]];
            NSString *urlOriginal = [NSString stringWithFormat:@"%@", [photo objectForKey:@"url_o"]];
            NSString *latitude = [NSString stringWithFormat:@"%@", [photo objectForKey:@"latitude"]];
            NSString *longitude = [NSString stringWithFormat:@"%@", [photo objectForKey:@"longitude"]];
            
            FlickrPicture *pic = [[FlickrPicture alloc]init];
            pic.idNumber = [numberFormatter numberFromString:idNumber]; 
            pic.title = title.length > 0 ? title : @"Untitled";
            pic.description = description;
            pic.ownerName = ownerName;
            pic.tags = tags.length == 0 ? NULL : [tags componentsSeparatedByString:@" "];
            pic.views = [numberFormatter numberFromString:views];
            pic.urlThumbnail = [urlThumbnail isEqualToString:@"(null)"] ? NULL : [NSURL URLWithString:urlThumbnail];
            pic.urlSmall = [urlSmall isEqualToString:@"(null)"] ? NULL : [NSURL URLWithString:urlSmall];
            pic.urlMedium = [urlMedium isEqualToString:@"(null)"] ? NULL : [NSURL URLWithString:urlMedium];
            pic.urlLarge = [urlLarge isEqualToString:@"(null)"] ? NULL : [NSURL URLWithString:urlLarge];
            pic.urlOriginal = [urlOriginal isEqualToString:@"(null)"] ? NULL : [NSURL URLWithString:urlOriginal];
            pic.latitude = [numberFormatter numberFromString:latitude];
            pic.longitude = [numberFormatter numberFromString:longitude];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            pic.dateTaken = [dateFormatter dateFromString:dateTaken];           
            
            [flickrPictures addObject:pic];
            
        }
        
        // Update the table with data
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    } else {
        
        [self showAlert: [NSString stringWithFormat: ERROR_NO_RESULTS, self.searchBar.text]];
        
    }
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    flickrConnection = nil;
    
    NSString *errorMessage = [NSString stringWithFormat:ERROR_CONNECTION_FAILED, [error localizedDescription]];
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:errorMessage delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [aSheet showInView:self.view.window];
    
}





/* ***************************************************** */
/*                                                       */
/*                  SEARCHBAR DELEGATES                  */
/*                                                       */
/* ***************************************************** */
#pragma mark - Searchbar Delegates


- (void) searchBarSearchButtonClicked:(UISearchBar *)sBar {    
    
    // Hide keyboard
    [sBar resignFirstResponder];
    
    viewAppearsFirstTime = NO;
    
    // Begin the call to Flickr
    currentPage = 1;
    [self searchFlickrPictures:sBar.text];
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)sBar {
    
	sBar.showsScopeBar = YES;
	[sBar sizeToFit];
    
	[sBar setShowsCancelButton:YES animated:YES];
    
	return YES;
    
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)sBar {
    
	sBar.showsScopeBar = NO;
	[sBar sizeToFit];
    
	[sBar setShowsCancelButton:NO animated:YES];
    
	return YES;
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)sBar {
    
    [sBar resignFirstResponder];
    
}


- (void)searchBar:(UISearchBar *)sBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
    if(selectedScope == FREE_TEXT_SEARCH) {
        
        sBar.placeholder = FREE_TEXT_SEARCH_PH;
        
    } else if(selectedScope == TAG_SEARCH) {
        
        sBar.placeholder = TAG_SEARCH_PH;
        
    }
    
}





/* ***************************************************** */
/*                                                       */
/*                       IBACTIONS                       */
/*                                                       */
/* ***************************************************** */
#pragma mark - IBActions


- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint bottomOffset = CGPointMake(0, [scrollView contentSize].height - scrollView.frame.size.height);
    
    // Show bottom toolbar when user scrolled down
    if(scrollView.contentOffset.y >= bottomOffset.y && flickrPictures.count != 0) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.75];
        self.bottomToolBar.alpha = 0.85;
        [UIView commitAnimations];
        
    } else {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.75];
        self.bottomToolBar.alpha = 0;
        [UIView commitAnimations];
        
    }
    
}


- (IBAction) buttonPreviousPageClicked {
    
    currentPage--;
    if(viewAppearsFirstTime) {
        [self loadRecentPictures];
    } else {
        [self searchFlickrPictures:self.searchBar.text];
    }
    
}


- (IBAction) buttonNextPageClicked {
    
    currentPage++;
    if(viewAppearsFirstTime) {
        [self loadRecentPictures];
    } else {
        [self searchFlickrPictures:self.searchBar.text];
    }
    
}





/* ***************************************************** */
/*                                                       */
/*                         ALERTS                        */
/*                                                       */
/* ***************************************************** */
#pragma mark - Alerts


- (void) showAlert:(NSString *)text {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Results" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView title];
    if([title isEqualToString:@"No Results"]) {
        [self.searchBar becomeFirstResponder];
    }
    
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
    
    return self.flickrPictures.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StartViewControllerCustomTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"pictureCell"];
    
    FlickrPicture *currentPic = [self.flickrPictures objectAtIndex:indexPath.row];
    
    cell.labelTitle.text = currentPic.title;   
    cell.labelOwner.text = currentPic.ownerName;    
    [cell.imageView setImageWithURL:currentPic.urlThumbnail placeholderImage:[UIImage imageNamed:@"placeholder_thumbnail.png"]];
    
    return cell;
    
}




/* ***************************************************** */
/*                                                       */
/*                  TABLE VIEW DELEGATE                  */
/*                                                       */
/* ***************************************************** */
#pragma mark - TableView Delegate


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    FlickrPicture *selectedPic = [self.flickrPictures objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    DetailTabBarController *detailTabBarController = segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"showDetails"]) {    
        
        detailTabBarController.flickrPicture = selectedPic;
        
    }
    
}





/* ***************************************************** */
/*                                                       */
/*                VIEW CONTROLLER METHODS                */
/*                                                       */
/* ***************************************************** */
#pragma mark - View Controller Methods


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if(self.savedSearchTerm) {
        
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
        
    }
    
    // set up observer for tag search notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTagSearch:) name:@"tagSearch" object:nil];
    
    // Set the keyboard appearance of the search bar to black
    for (UIView *searchBarSubview in [self.searchBar subviews]) {
        
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {            
            @try { [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert]; }
            @catch (NSException * e) {}            
        }
        
    }
    
    viewAppearsFirstTime = YES;
    currentPage = 1;
    [self loadRecentPictures];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    
    // Save the states of the searchbar so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
}


- (void)viewWillAppear:(BOOL)animated {  
    
    // Deselect any previous selected table cells
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
}


- (void)viewDidUnload {
    
    [self setLabelTotalNumber:nil];
    [self setLabelPageNumber:nil];
    [self setButtonPreviousPage:nil];
    [self setButtonNextPage:nil];
    [self setSearchBar:nil];
    [self setBottomToolBar:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    
}





/* ***************************************************** */
/*                                                       */
/*                NOTIFICATIONS OBSERVER                 */
/*                                                       */
/* ***************************************************** */
#pragma mark - Notifications Observer


- (void) notificationTagSearch:(NSNotification*) notification {
    
    NSString *tag = notification.object;
    self.searchBar.text = tag;
    self.searchBar.selectedScopeButtonIndex = 1;
    
    [self searchFlickrPictures:tag];
    
}

@end