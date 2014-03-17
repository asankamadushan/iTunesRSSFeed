//
//  AMCoreDataManager.h
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

@interface AMCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
