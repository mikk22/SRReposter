//
//  SRDatabaseManager.m
//  SRReposter
//
//

#import "SRDatabaseManager.h"

@implementation SRDatabaseManager


+(BOOL)_itemEqualTo:(id)feedItem withFeed:(CDFeed*)feed inContext:(NSManagedObjectContext*)localContext
{
    NSString *link=[feedItem valueForKey:@"link"] ? [feedItem valueForKey:@"link"] : @"";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"link == %@",link];
    NSSet  *filteredItemsSet=[feed.items filteredSetUsingPredicate:predicate];
    return (filteredItemsSet.count ? YES : NO);
}

+(NSArray*)filterNewFeedItems:(NSArray*)feedItems withFeed:(CDFeed*)feed
{
    NSMutableArray *newFeedItems=[NSMutableArray array];
    
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (id feedItem in feedItems)
    {
        if (![SRDatabaseManager _itemEqualTo:feedItem  withFeed:feed inContext:localContext])
            [newFeedItems addObject:feedItem];
    }
    
    return [NSArray arrayWithArray:newFeedItems];
}


+(CDFeedItem*)_addFeedItem:(id)feedItem withFeed:(CDFeed*)feed inContext:(NSManagedObjectContext*)localContext
{
    CDFeedItem *cdFeedItem=[CDFeedItem MR_createInContext:localContext];
    cdFeedItem.date=[feedItem valueForKey:@"date"] ? [feedItem valueForKey:@"date"] : nil;
    cdFeedItem.content=[feedItem valueForKey:@"content"] ? [feedItem valueForKey:@"content"] : nil;
    cdFeedItem.identifier=[feedItem valueForKey:@"identifier"] ? [feedItem valueForKey:@"identifier"] : nil;
    cdFeedItem.title=[feedItem valueForKey:@"title"] ? [feedItem valueForKey:@"title"] : nil;
    cdFeedItem.link=[feedItem valueForKey:@"link"] ? [feedItem valueForKey:@"link"] : nil;
    cdFeedItem.summary=[feedItem valueForKey:@"summary"] ? [feedItem valueForKey:@"summary"] : nil;
    cdFeedItem.updated=[feedItem valueForKey:@"updated"] ? [feedItem valueForKey:@"updated"] : nil;
    cdFeedItem.timestamp=[NSDate date];
    cdFeedItem.feed=[feed MR_inContext:localContext];

    return cdFeedItem;
}


+(NSArray*)addFeedItems:(NSArray*)feedItems withFeed:(CDFeed*)feed
{
    NSMutableArray *resultNewItems=[NSMutableArray array];
    
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray *newFeedItems=[SRDatabaseManager filterNewFeedItems:feedItems withFeed:feed];
    for (id feedItem in newFeedItems)
    {
        CDFeedItem *cdFeedItem=[SRDatabaseManager _addFeedItem:feedItem withFeed:feed inContext:localContext];
        [resultNewItems addObject:cdFeedItem];
    }
    
    if (newFeedItems.count)
    {
        DLog(@"ADDED_TO_CD %d",resultNewItems.count);
        [localContext MR_saveToPersistentStoreAndWait];
    }
    
    return [NSArray arrayWithArray:resultNewItems];
}


+(NSArray*)findLastFeedItemsWithFeed:(CDFeed*)feed limitTo:(NSUInteger)feedItemsLimit
{
    return [SRDatabaseManager findFeedItemsWithFeed:feed fromOffset:0 limitTo:feedItemsLimit];
}



+(NSArray*)findFeedItemsWithFeed:(CDFeed*)feed fromOffset:(NSUInteger)feedItemsOffset limitTo:(NSUInteger)feedItemsLimit
{
    if (feedItemsOffset<feed.items.count)
    {
        NSUInteger limit=((feedItemsOffset+feedItemsLimit)<feed.items.count) ? feedItemsLimit : feed.items.count;
        return [[feed.items allObjects] subarrayWithRange:NSMakeRange(feedItemsOffset, limit)];
    }
    
    return [NSArray array];
}



+(void)removeFeed:(CDFeed*)feed
{
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];

    if (feed.items.count)
        [feed.items makeObjectsPerformSelector:@selector(MR_deleteEntity)];
    if (feed.filters.count)
        [feed.filters makeObjectsPerformSelector:@selector(MR_deleteEntity)];

    [feed MR_deleteInContext:localContext];
    [localContext MR_saveToPersistentStoreAndWait];
}




@end
