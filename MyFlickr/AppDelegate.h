//
//  AppDelegate.h
//  MyFlickr
//
//  Created by Jens Driller on 03/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    Reachability *internetReachable;
    
}

@property (strong, nonatomic) UIWindow *window;

- (void) checkNetworkStatus:(NSNotification*)notice;

@end