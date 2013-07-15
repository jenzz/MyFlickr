//
//  DetailWebViewController.m
//  MyFlickr
//
//  Created by Jens Driller on 07/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "DetailWebViewController.h"

@implementation DetailWebViewController

@synthesize webView, urlToLoad;


/* ***************************************************** */
/*                                                       */
/*                VIEW CONTROLLER METHODS                */
/*                                                       */
/* ***************************************************** */
#pragma mark - View Controller Methods


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(self.urlToLoad) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.urlToLoad]];
        
    }
    
}


- (void)viewDidUnload {
    
    [self setWebView:nil];
    [super viewDidUnload];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    
}





/* ***************************************************** */
/*                                                       */
/*                       IBACTIONS                       */
/*                                                       */
/* ***************************************************** */
#pragma mark - IBActions


- (IBAction)loadExternalBrowser {
    
    NSURL *currentUrl = self.webView.request.URL;
    [[UIApplication sharedApplication] openURL:currentUrl];
    
}

@end