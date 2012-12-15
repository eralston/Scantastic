//
//  Library.h
//  ReaderSample
//
//  Created by Ralston, Erik J on 12/14/12.
//  Copyright (c) 2012 ZBar Consulting Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Patron.h"
#import "Item.h"
#import "Transaction.h"

///
/// A simple singleton class that manages access to the CoreData model
/// This is used for creating entries for testing and accessing them during the transaction
///
@interface Library : NSObject

// singleton instance
+ (Library *) shared;

// actions on the entire repository
- (void)save;
- (void)deleteEntireDatabase;

- (void)seedIfEmpty;

// methods for Patron
- (Patron *)insertNewPatronWithName:(NSString *)name identifier:(NSString *)identifier pin:(NSString *)pin;
- (Patron *)findPatronByIdentifier:(NSString *)identifier;

// methods for Item
- (Item *)insertNewItemWithName:(NSString *)name identifier:(NSString *)identifier;
- (Item *)findItemByIdentifier:(NSString *)identifier;

// methods for Transaction
- (Transaction *)insertNewTransactionForPatron:(Patron *)patron;
- (void)deleteTransaction:(Transaction *)transaction;

@end
