//
//  AMSongsRepository.h
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/29/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMRepository.h"

/** This class can use to retrive songs data from database */
@interface AMSongsLibrary : AMRepository

/* getAll songs in the database 
    @return An array of Songs objects.
 */
- (NSArray *)getAllSongs;

@end
