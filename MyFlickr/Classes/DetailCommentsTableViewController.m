//
//  DetailCommentsTableViewController.m
//  MyFlickr
//
//  Created by Jens Driller on 04/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "DetailCommentsTableViewController.h"
#import "DetailCommentsTableViewCustomCell.h"
#import "DetailTabBarController.h"
#import "Constants.h"
#import "FlickrPicture.h"
#import "FlickrPictureComment.h"
#import "UIImageView+WebCache.h"
#import "SDNetworkActivityIndicator.h"

@implementation DetailCommentsTableViewController


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
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.comments.getList&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", FLICKR_API_KEY, detailTabBarController.flickrPicture.idNumber];  

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    if(flickrConnection) {
        [flickrConnection cancel];
        flickrConnection = nil;
    }
    flickrConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
      
    if(detailTabBarController.flickrPicture.comments == nil) {
        detailTabBarController.flickrPicture.comments = [[NSMutableArray alloc] init];
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
    
    //NSDictionary *metaData = ;
    NSArray *comments = [[results objectForKey:@"comments"] objectForKey:@"comment"];
    
    // If comments found
    if(comments.count != 0) {
        
        [detailTabBarController.flickrPicture.comments removeAllObjects];
                
        // Iterate over all found comments  
        for (NSDictionary *comment in comments) {
            
            NSString *idNumber = [NSString stringWithFormat:@"%@", [comment objectForKey:@"id"]];
            NSString *authorId = [NSString stringWithFormat:@"%@", [comment objectForKey:@"author"]];
            NSString *authorName = [NSString stringWithFormat:@"%@", [comment objectForKey:@"authorname"]];
            NSString *date = [NSString stringWithFormat:@"%@", [comment objectForKey:@"datecreate"]];
            NSString *commentText = [NSString stringWithFormat:@"%@", [comment valueForKey:@"_content"]];
            NSString *iconServer = [NSString stringWithFormat:@"%@", [comment objectForKey:@"iconserver"]];
            NSString *iconFarm = [NSString stringWithFormat:@"%@", [comment objectForKey:@"iconfarm"]];
            
            FlickrPictureComment *newComment = [[FlickrPictureComment alloc] init];
            newComment.idNumber = idNumber;
            newComment.authorId = authorId;
            newComment.authorName = authorName;
            newComment.comment = commentText;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            newComment.date = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
            
            if([iconServer intValue] > 0) {
                newComment.urlAuthorIcon = [NSURL URLWithString:[NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/buddyicons/%@.jpg", iconFarm, iconServer, authorId]];
            } else {
                newComment.urlAuthorIcon = [NSURL URLWithString:@"http://www.flickr.com/images/buddyicon.jpg"];
            }
            
            [detailTabBarController.flickrPicture.comments addObject:newComment];
            
        }
        
        // Update the table with data
        [self.tableView reloadData];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    flickrConnection = nil;
    
    NSString *errorMessage = [NSString stringWithFormat:ERROR_CONNECTION_FAILED, [error localizedDescription]];
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:errorMessage delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [aSheet showInView:self.view.window];
    
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
    
    if(detailTabBarController.flickrPicture.comments.count == 0) {
        return 1;
    } else {
        return detailTabBarController.flickrPicture.comments.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailCommentsTableViewCustomCell *cell;
    
    if(detailTabBarController.flickrPicture.comments.count == 0) { 
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"noCommentsCell"];
        return cell;
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        FlickrPictureComment *currentComment = [detailTabBarController.flickrPicture.comments objectAtIndex:indexPath.row];
        
        cell.authorName.text = currentComment.authorName;
        cell.comment.text = currentComment.comment;
        [cell.authorImage setImageWithURL:currentComment.urlAuthorIcon placeholderImage:[UIImage imageNamed:@"icon_buddy.jpg"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, dd MMMM yyyy - HH:mm:ss"];
        cell.date.text = [dateFormatter stringFromDate:currentComment.date];
        
        // Dynamically resize comment textfield
        UITextView *textV = cell.comment;
        CGRect frame = textV.frame;
        frame.size.height = textV.contentSize.height;
        textV.frame = frame;
        
        return cell;
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(detailTabBarController.flickrPicture.comments.count == 0) {
        
        return 44.0f;
        
    } else {
    
        FlickrPictureComment *currentComment = [detailTabBarController.flickrPicture.comments objectAtIndex:indexPath.row];

        // Dynamically resize height of table cell
        CGSize constraintSize = CGSizeMake(234.0f, MAXFLOAT); // 234px = default textview width
        CGSize stringSize = [currentComment.comment sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
    
        return stringSize.height + 2 * 36.0f; // 33px = margin (top & bottom)
        
    }
    
}

@end