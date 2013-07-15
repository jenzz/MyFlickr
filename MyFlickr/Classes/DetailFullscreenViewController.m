//
//  DetailFullscreenViewController.m
//  MyFlickr
//
//  Created by Jens Driller on 01/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "DetailFullscreenViewController.h"
#import "DetailTabBarController.h"
#import "FlickrPicture.h"
#import "UIImageView+WebCache.h"
#import "SDNetworkActivityIndicator.h"

@implementation DetailFullscreenViewController

@synthesize scrollView, imageView, urlMedium;


/* ***************************************************** */
/*                                                       */
/*                VIEW CONTROLLER METHODS                */
/*                                                       */
/* ***************************************************** */
#pragma mark - View Controller Methods


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(self.urlMedium) {
        
        [self.imageView setImageWithURL:self.urlMedium placeholderImage:[UIImage imageNamed:@"placeholder_detail.png"]];
        
    }
    
    
}


- (void)viewDidUnload {
    
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    
}





/* ***************************************************** */
/*                                                       */
/*                        ZOOMING                        */
/*                                                       */
/* ***************************************************** */
#pragma mark - Zooming


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
    
}


- (IBAction)handleTap:(id)sender {
    
    // Reset zoom and rotation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
        self.scrollView.zoomScale = 1.0f;
        self.scrollView.transform = CGAffineTransformMakeRotation(0.0f);
    [UIView commitAnimations];
    
}





/* ***************************************************** */
/*                                                       */
/*                       ROTATION                        */
/*                                                       */
/* ***************************************************** */
#pragma mark - Rotation


- (IBAction)handleRotation:(id)sender {
    
    UIRotationGestureRecognizer *recognizer = sender;
    
    if(recognizer.state == UIGestureRecognizerStateBegan ||
       recognizer.state == UIGestureRecognizerStateChanged) {
        
        self.scrollView.transform = CGAffineTransformRotate(self.scrollView.transform, recognizer.rotation);
        recognizer.rotation = 0.0f;
        
    }
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}

@end