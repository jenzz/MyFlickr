//
//  AppDelegate.m
//  MyFlickr
//
//  Created by Jens Driller on 03/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // Check network status directly after app launches
    [self performSelector:@selector(checkNetworkStatus:) withObject:nil];
    
    return YES;
    
}

// Called by Reachability whenever status changes.
- (void) checkNetworkStatus:(NSNotification*)notice {
    
    NetworkStatus netStatus = [internetReachable currentReachabilityStatus];
    
    switch (netStatus) {
            
        case ReachableViaWWAN: {
            break;
        }
            
        case ReachableViaWiFi: {
            break;
        }
            
        case NotReachable: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection!" message:@"This app requires a valid internet connection to work. We are unable to make a internet connection at this time. Please check your settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
            
        }
            
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}

@end