//
//  Constants.m
//  MyFlickr
//
//  Created by Jens Driller on 30/11/2011.
//  Copyright (c) 2011 Jens Driller. All rights reserved.
//

/* Flickr API Key */
#error -- Put Flickr API Key here --
NSString* const FLICKR_API_KEY = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

/* How many pictures should be loaded per page? */
int const PICS_PER_PAGE = 20;

/* Search bar scopes + placeholders */
int const FREE_TEXT_SEARCH = 0;
int const TAG_SEARCH = 1;
NSString* const FREE_TEXT_SEARCH_PH = @"Free Text Search...";
NSString* const TAG_SEARCH_PH = @"Tag Search...";

/* Error Message: No search results */
NSString* const ERROR_NO_RESULTS = @"Sorry, no pictures found for \"%@\".";

/* Error Message: Flickr connection failed */
NSString* const ERROR_CONNECTION_FAILED = @"Flickr download failed. %@";

/* Google/Wikipedia Tag Search URLs */
NSString* const GOOGLE_SEARCH_URL = @"http://www.google.com/search?q=%@";
NSString* const WIKIPEDIA_SEARCH_URL = @"http://en.wikipedia.org/wiki/Special:Search?search=%@";