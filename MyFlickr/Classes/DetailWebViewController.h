//
//  DetailWebViewController.h
//  MyFlickr
//
//  Created by Jens Driller on 07/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailWebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *urlToLoad;

- (IBAction)loadExternalBrowser;

@end