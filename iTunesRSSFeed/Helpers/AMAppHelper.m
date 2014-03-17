//
//  AMAppHelper.m
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMAppHelper.h"

@implementation AMAppHelper

+ (NSURL *)documentDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
