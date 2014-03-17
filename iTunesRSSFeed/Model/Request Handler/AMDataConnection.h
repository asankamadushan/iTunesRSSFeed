//
//  AMDataConnection.h
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

@class AMDataStore;

@interface AMDataConnection : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) AMDataStore *dataStore;

/* Initialize AMDataConnection with url
 @param url a valide url(RSS feed) to download data.
 @return an AMDataConnection object.
 */
- (id)initWithURL:(NSURL *)url;

@end
