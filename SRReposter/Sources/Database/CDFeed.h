//
//  CDFeed.h
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDFeedFilter, CDFeedItem;

@interface CDFeed : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *filters;
@end

@interface CDFeed (CoreDataGeneratedAccessors)

- (void)addItemsObject:(CDFeedItem *)value;
- (void)removeItemsObject:(CDFeedItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addFiltersObject:(CDFeedFilter *)value;
- (void)removeFiltersObject:(CDFeedFilter *)value;
- (void)addFilters:(NSSet *)values;
- (void)removeFilters:(NSSet *)values;

@end
