//
//  AMDataModel.m
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMDataStore.h"
#import "AMCoreDataManager.h"
#import "AMSongsLibrary.h"

@implementation AMDataStore

- (id)init
{
    if (self = [super init])
    {
        self.coreDataManager = [[AMCoreDataManager alloc] init];
        self.songsLibrary = [[AMSongsLibrary alloc] initWithManagedObjectContext:_coreDataManager.managedObjectContext];
    }
    
    return self;
}

@end
