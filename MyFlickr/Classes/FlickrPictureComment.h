//
//  FlickrPictureComment.h
//  MyFlickr
//
//  Created by Jens Driller on 05/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPictureComment : NSObject

@property (copy, nonatomic) NSString *idNumber;
@property (copy, nonatomic) NSString *authorId;
@property (copy, nonatomic) NSString *authorName;
@property (strong, nonatomic) NSURL *urlAuthorIcon;
@property (strong, nonatomic) NSDate *date;
@property (copy, nonatomic) NSString *comment;

@end