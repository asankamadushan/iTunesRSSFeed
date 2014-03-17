//
//  AMDataConnection.m
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMDataConnection.h"
#import "AMXMLHandler.h"

@implementation AMDataConnection
{
    NSURLConnection *_urlConnection;
    AMXMLHandler *_xmlPreaser;
    NSMutableData *_xmlData;
}

- (id)initWithURL:(NSURL *)url
{
    if (self = [super init])
    {
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        _urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    return self;
}

#pragma NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!_xmlData)
    {
        _xmlData = [[NSMutableData alloc] init];
    }
    
    [_xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _xmlPreaser = [[AMXMLHandler alloc] initWithData:_xmlData];
    _xmlPreaser.dataStore = self.dataStore;
    [_xmlPreaser prase];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *connectionFailMessage = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:errorMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
    [connectionFailMessage show];
}

@end
