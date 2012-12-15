//
//  Library.m
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#import "Library.h"

#import "Patron.h"
#import "Item.h"
#import "Transaction.h"

@interface Library ()
{
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_objectModel;
    NSPersistentStoreCoordinator *_coordinator;
}

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel *objectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;

@end

@implementation Library

#pragma mark - Singleton Implementation

+ (Library *)shared
{
    static Library *instance = nil;
    
    if(!instance)
        instance = [[super allocWithZone:nil] init];
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shared];
}

#pragma mark - Supporting CoreData Instances

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)context
{
    if(!_context) {
        NSPersistentStoreCoordinator *coordinator = [self coordinator];
        if (coordinator != nil) {
            _context = [[NSManagedObjectContext alloc] init];
            [_context setPersistentStoreCoordinator:coordinator];
        }
    }
    return _context;
}

- (NSManagedObjectModel *)objectModel
{
    if(!_objectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Library" withExtension:@"momd"];
        _objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _objectModel;
}

- (NSPersistentStoreCoordinator *)coordinator
{
    if(!_coordinator) {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"miops_data.sqlite"];
        
        NSError *error = nil;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self objectModel]];
        if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            
            // Replace this implementation with code to handle the error appropriately.
            // This just deletes the file then crashes the app
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            
            NSLog(@"Unresolved Persistent Store error %@, %@", error, [error userInfo]);
            
            abort();
        }
        
        NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
        if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[storeURL path] error:&error])
        {
            NSLog(@"Unresolved FileProtectionComplete error %@, %@", error, [error userInfo]);
            abort();
        }

    }
    return _coordinator;
}

#pragma mark - Data Access Support

- (void)seedIfEmpty
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    NSArray *array = [self executeFetchRequest:request];
    
    if([array count] == 0) {
        [self insertNewPatronWithName:@"Erik" identifier:@"23629001012001" pin:@"1234"];
        [self insertNewPatronWithName:@"Bruce" identifier:@"23629001015170" pin:@"1234"];
        [self insertNewPatronWithName:@"Jon" identifier:@"c" pin:@"1234"];
        [self insertNewPatronWithName:@"Shenoa" identifier:@"d" pin:@"1234"];
        
        [self insertNewItemWithName:@"Batman: The Dark Knight Returns" identifier:@"1"];
        [self insertNewItemWithName:@"Watchmen" identifier:@""];
        [self insertNewItemWithName:@"V for Vendetta" identifier:@""];
        
        // try making a transaction
        Patron *patron = [self findPatronByIdentifier:@"b"];
        Transaction *trans = [self insertNewTransactionForPatron:patron];
        Item *item = [self findItemByIdentifier:@"1"];
        [trans addItemsObject:item];
        
        [self save];
    }
}

// actions on the entire repository
- (void)save
{
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = [self context];
	if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			
			// Replace this implementation with code to handle the error appropriately.
			
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

- (void)deleteEntireDatabase
{
    NSManagedObjectContext *context = [self context];
    NSPersistentStoreCoordinator *coordinator = [self coordinator];
    NSURL * storeURL = [coordinator URLForPersistentStore:[[coordinator persistentStores] lastObject]];
    
	[self.context lock];
    
    // Notify those that care to release their reference of the MOC
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MocUpdate" object:@"PreUpdate"];
	[context reset];
    
    if ([coordinator removePersistentStore:coordinator.persistentStores.lastObject error:nil])
	{
		// remove the file containing the data
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        // Remove the reference to the persistent store coordinator and have it re-created
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
								 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
		[coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:nil];//creates a new persistent store
    }
    
	[context unlock];
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MocUpdate" object:@"PostUpdate"];
    
	NSLog(@"Reset local databases.");
}

///
/// Executes the given fetch request, returning the result as an array
///
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
{
    NSLog(@"Executing fetch request for entity '%@' with query: '%@'", [request entityName], [[request predicate] predicateFormat]);
    return [[self context] executeFetchRequest:request error:nil];
}

///
/// Executes a request for the given entity with the given predicate format, returning the resulting array
/// This is intended to return from a query with multiple values
///
- (NSArray *)executeFetchRequestForEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [request setPredicate:predicate];
    return [self executeFetchRequest:request];
}

///
/// Executes a request for the given entity with the given predicate format, returning the resulting array
/// This is intended to return from a query with multiple values
///
- (id)executeFetchRequestForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [request setPredicate:predicate];
    return [[self executeFetchRequest:request] lastObject];
}

#pragma mark - Data Access

// methods for Patron
- (Patron *)insertNewPatronWithName:(NSString *)name identifier:(NSString *)identifier pin:(NSString *)pin
{
    Patron *newPatron = [NSEntityDescription insertNewObjectForEntityForName:@"Patron" inManagedObjectContext:[self context]];
    
    [newPatron setName:name];
    [newPatron setIdentifier:identifier];
    [newPatron setPin:pin];
    
    return newPatron;
}

- (Patron *)findPatronByIdentifier:(NSString *)identifier
{
    return [self executeFetchRequestForEntity:@"Patron" withPredicate:[NSPredicate predicateWithFormat:@"identifier like %@", identifier]];
}

// methods for Item
- (Item *)insertNewItemWithName:(NSString *)name identifier:(NSString *)identifier
{
    Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:[self context]];
    
    [newItem setName:name];
    [newItem setIdentifier:identifier];
    
    return newItem;
}

- (Item *)findItemByIdentifier:(NSString *)identifier
{
    return [self executeFetchRequestForEntity:@"Item" withPredicate:[NSPredicate predicateWithFormat:@"identifier like %@", identifier]];
}

// methods for Transaction
- (Transaction *)insertNewTransactionForPatron:(Patron *)patron
{
    Transaction *newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:[self context]];
    
    [newTransaction setPatron:patron];
    
    return newTransaction;
}

- (void)deleteTransaction:(Transaction *)transaction
{
    [[self context] deleteObject:transaction];
}

@end
