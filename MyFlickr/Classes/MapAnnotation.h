//
//  MapAnnotation.h
//  MyFlickr
//
//  Created by Jens Driller on 13/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end