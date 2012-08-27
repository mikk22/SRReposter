//
//  SRDatabaseManager.h
//  SRReposter
//
//

#import <Foundation/Foundation.h>
#import "CDFeedItem.h"
#import "CDFeed.h"
#import "CDFeedFilter.h"


@interface SRDatabaseManager : NSObject

//@property (nonatomic, strong, readonly)   DVSCoreDataDatabase *database;

+(NSArray*)filterNewFeedItems:(NSArray*)feedItems withFeed:(CDFeed*)feed;

+(NSArray*)addFeedItems:(NSArray*)feedItems withFeed:(CDFeed*)feed;

+(NSArray*)findLastFeedItemsWithFeed:(CDFeed*)feed limitTo:(NSUInteger)feedItemsLimit;
+(NSArray*)findFeedItemsWithFeed:(CDFeed*)feed fromOffset:(NSUInteger)feedItemsOffset limitTo:(NSUInteger)feedItemsLimit;

+(void)removeFeed:(CDFeed*)feed;

@end
