//
//  AMRepository.h
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/29/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

/** This is the base class for all the data retrivng classes */
@interface AMRepository : NSObject

/* Initialize ManagedObjectContext with */
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/* Return New entity by type.
 @param type Name of the entity type
 @return entity by is type.
*/
- (id)getNewEntityByType:(NSString *)type;

/* Return list of entities quary from the database
 @param type Name of the entity.
 @param predicate The filer conditions for the quary.
 @param descriptors Colums for sorting.
 @param propertiesToFetch filer properties fromt the result.
 @param returnsDistinctResults YES if the results need to be in the type of a dictionaty.
 @return Result in the form of an array.
 */
- (NSArray *)getEntitiesByType:(NSString *)type
                     predicate:(NSPredicate *)predicate
               sortDescriptors:(NSArray *)descriptors
             propertiesToFetch:(NSArray *)propertiesToFetch
        returnsDistinctResults:(BOOL)returnsDistinctResults;

/* Delete all objects of given type entity 
 @param type Entity type
 @return YES/NO weather the operation complete with our errors;
 */
- (BOOL)removeAllObjectsInEntity:(NSString *)type;

@end
