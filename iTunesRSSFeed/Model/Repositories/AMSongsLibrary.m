//
//  AMSongsRepository.m
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/29/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMSongsLibrary.h"
#import "Songs.h"

@implementation AMSongsLibrary

- (NSArray *)getAllSongs
{
    return [super getEntitiesByType:NSStringFromClass([Songs class]) predicate:nil sortDescriptors:nil propertiesToFetch:nil returnsDistinctResults:NO];
}

@end
