//
//  DetailMapViewController.m
//  MyFlickr
//
//  Created by Jens Driller on 13/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "DetailMapViewController.h"
#import "DetailTabBarController.h"
#import "FlickrPicture.h"
#import "MapAnnotation.h"

@implementation DetailMapViewController
@synthesize mapView;


/* ***************************************************** */
/*                                                       */
/*                VIEW CONTROLLER METHODS                */
/*                                                       */
/* ***************************************************** */
#pragma mark - View Controller Methods


- (void) viewDidLoad {
    
    if(detailTabBarController == nil) {
        detailTabBarController = (DetailTabBarController *) self.tabBarController;
    }
    
    [super viewDidLoad];
}


- (void) viewDidAppear:(BOOL)animated {
    
    if([detailTabBarController.flickrPicture.latitude isEqualToNumber:[NSNumber numberWithInt:0]] ||
       [detailTabBarController.flickrPicture.longitude isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry, no geo-data!" message:@"The photo's location cannot be marked on the map as no geo-data is provided." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    } else {
        
        CLLocationCoordinate2D location;
        location.latitude = [detailTabBarController.flickrPicture.latitude doubleValue];
        location.longitude = [detailTabBarController.flickrPicture.longitude doubleValue];
        
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.coordinate = location;
        annotation.title = detailTabBarController.flickrPicture.title;
        annotation.subtitle = detailTabBarController.flickrPicture.ownerName;
        
        [self.mapView addAnnotation:annotation];
    
    }
    
}


- (void)viewDidUnload {
    
    [self setMapView:nil];
    [super viewDidUnload];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
}





/* ***************************************************** */
/*                                                       */
/*                  MAP CONFIGURATION                    */
/*                                                       */
/* ***************************************************** */
#pragma mark - Map Configuration


// When a map annotation point is added, zoom to it (range: 3000)
- (void)mapView:(MKMapView *)mkMapView didAddAnnotationViews:(NSArray *)views {
    
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 3000, 3000);
    
	[mkMapView setRegion:region animated:YES];
	[mkMapView selectAnnotation:mp animated:YES];
    
}





/* ***************************************************** */
/*                                                       */
/*                       IBACTIONS                       */
/*                                                       */
/* ***************************************************** */
#pragma mark - IBActions


- (IBAction)mapTypeChanged:(id)sender {
    
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
            
        case 0: {
            self.mapView.mapType = MKMapTypeStandard;
            break;
        }
        case 1: {
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        }
        case 2: {
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        }

    }
}

@end