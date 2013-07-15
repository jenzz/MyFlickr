//
//  FlickrPicture.h
//  MyFlickr
//
//  Created by Jens Driller on 29/11/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPicture : NSObject

@property (strong, nonatomic) NSNumber *idNumber;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *urlThumbnail;
@property (strong, nonatomic) NSURL *urlSmall;
@property (strong, nonatomic) NSURL *urlMedium;
@property (strong, nonatomic) NSURL *urlLarge;
@property (strong, nonatomic) NSURL *urlOriginal;
@property (copy, nonatomic) NSString *ownerName;
@property (copy, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *dateTaken;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSNumber *views;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSMutableArray *comments;

@end