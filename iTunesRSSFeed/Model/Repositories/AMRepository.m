//
//  AMRepository.m
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/29/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMRepository.h"

#import "Songs.h"

@implementation AMRepository
{
    NSManagedObjectContext *_managedObjectContext;
}

- (id)init
{
    [NSException raise:@"Invalid initializer" format:@"Initializer 'init' is not valid, use 'initWithManagedObjectContext:' instead."];
    return nil;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSParameterAssert(managedObjectContext);
    
    if (self = [super init])
    {
        _managedObjectContext = managedObjectContext;
    }
    
    return self;
}

- (id)getNewEntityByType:(NSString *)type
{
	return [NSEntityDescription insertNewObjectForEntityForName:type inManagedObjectContext:_managedObjectContext];
}

- (NSArray *)getEntitiesByType:(NSString *)type predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)descriptors propertiesToFetch:(NSArray *)propertiesToFetch returnsDistinctResults:(BOOL)returnsDistinctResults
{
	NSError *error = nil;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSArray *fetchedResultsArray;
	NSEntityDescription *fetchEntity = [NSEntityDescription entityForName:type inManagedObjectContext:_managedObjectContext];
	
	fetchRequest.entity = fetchEntity;
	fetchRequest.predicate = predicate;
	fetchRequest.sortDescriptors = descriptors;
	[fetchRequest setPropertiesToFetch:propertiesToFetch];
	[fetchRequest setReturnsDistinctResults:returnsDistinctResults];
    
	if (returnsDistinctResults)
    {
		[fetchRequest setResultType:NSDictionaryResultType];
	}
	
    fetchedResultsArray = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
	if (error != nil)
    {
		NSLog(@"Error when fetching object for entity type: %@, predicate: %@, error: %@", type, [predicate predicateFormat], [error localizedDescription]);
	}
	
	return fetchedResultsArray;
}

- (BOOL)removeAllObjectsInEntity:(NSString *)type
{
    NSError *error;
    NSArray *songsArray = [self getEntitiesByType:type predicate:nil sortDescriptors:nil propertiesToFetch:nil returnsDistinctResults:NO];
    
    for (NSManagedObject *song in songsArray)
    {
        [_managedObjectContext deleteObject:song];
    }
    
    return [_managedObjectContext save:&error];
}

@end
