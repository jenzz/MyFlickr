//
//  DetailTabBarController.m
//  MyFlickr
//
//  Created by Jens Driller on 03/12/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

#import "DetailTabBarController.h"
#import "FlickrPicture.h"

@implementation DetailTabBarController

@synthesize flickrPicture;


/* ***************************************************** */
/*                                                       */
/*                       IBACTIONS                       */
/*                                                       */
/* ***************************************************** */
#pragma mark - IBActions


- (IBAction) sharePicture {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil && [mailClass canSendMail]) {

        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        mailComposer.navigationBar.barStyle = UIBarStyleBlack;

        [mailComposer setSubject:self.flickrPicture.title];
        NSData *myData = [NSData dataWithContentsOfURL:self.flickrPicture.urlSmall];
        [mailComposer addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    
        NSString *emailBody = [NSString stringWithString:@"Hey, look what I've found on Flickr.<br/><br/>(Photo attached)"];
    
        [mailComposer setMessageBody:emailBody isHTML:YES];
    
        [self presentModalViewController:mailComposer animated:YES];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Missing email configuration. Please set up your email account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
}


- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
	switch (result) {
            
        case MFMailComposeResultCancelled: {
            alert.title = @"Draft deleted";
			alert.message = @"E-Mail draft successfully deleted.";
			break;
        }
        case MFMailComposeResultSaved: {
            alert.title = @"Draft saved";
			alert.message = @"E-Mail draft successfully saved. Check your email app.";
			break;
        }
		case MFMailComposeResultSent: {
            alert.title = @"E-Mail sent";
			alert.message = @"E-Mail successfully sent.";
			break;
        }
		case MFMailComposeResultFailed: {
            alert.title = @"Sending email failed";
			alert.message = @"An error occurred during the sending process.";
			break;
        }
        default: {
            break; 
        }
            
	}
    
    [self performSelector:@selector(showDelayedAlert:) withObject:alert afterDelay:0.1];
    
}


- (void) showDelayedAlert:(UIAlertView *)alert {
    
    [alert show];
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView.title isEqualToString:@"Error"]) {
        
        // Open email configuration
        NSString *stringURL = @"mailto:";
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
    if(![alertView.title isEqualToString:@"Draft saved"]) {
        
        [self setSelectedIndex:0];
        [self dismissModalViewControllerAnimated:YES];
        
    }
    
}





/* ***************************************************** */
/*                                                       */
/*                VIEW CONTROLLER METHODS                */
/*                                                       */
/* ***************************************************** */
#pragma mark - View Controller Methods


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // All orientations for CommentsView, TagsView and MapView
    if(self.selectedIndex == 1 || self.selectedIndex == 2 || self.selectedIndex == 3) {
        
        return YES;
        
    } else { // Portrait only for PictureView and DownloadView
        
        return interfaceOrientation == UIInterfaceOrientationPortrait ||
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
        
    }
    
}


- (void)viewDidUnload {
    
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end