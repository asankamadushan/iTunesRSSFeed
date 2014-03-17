//
//  AMXMLHandler.h
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

@class AMDataStore;

@interface AMXMLHandler : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) AMDataStore *dataStore;

/* Initialize AMXMLHandler object with data 
 @param data XMdata in the form of NSdata.
 @return AMXMLHandler object.
 */
- (id)initWithData:(NSData *)data;

/* This method will start prosessing XML data
 @return YES/NO weather the peosess has compleated with out errors.
 */
- (BOOL)prase;

@end
