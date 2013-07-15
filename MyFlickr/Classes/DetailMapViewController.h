//
//  DetailMapViewController.h
//  MyFlickr
//
//  Created by Jens Driller on 13/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DetailTabBarController;

@interface DetailMapViewController : UIViewController {
    
    DetailTabBarController *detailTabBarController;
    
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)mapTypeChanged:(id)sender;

@end