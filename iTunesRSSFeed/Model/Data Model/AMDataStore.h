//
//  AMDataModel.h
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

@class AMCoreDataManager;
@class AMSongsLibrary;

/** This class wrap all the bd model objects */
@interface AMDataStore : NSObject

// coreDataManager instance for perfome all database operations.
@property (nonatomic, strong) AMCoreDataManager *coreDataManager;

// songsRepository retrive data related to Songs.
@property (nonatomic, strong) AMSongsLibrary *songsLibrary;

@end
