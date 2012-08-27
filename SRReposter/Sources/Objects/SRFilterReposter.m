//
//  SRFilterReposter.m
//  SRReposter
//
//  Created by user on 25.08.12.
//

#import "SRFilterReposter.h"
#import "CDFeedFilter.h"
#import "SRFBConnect.h"
#import "SRTwitterReposter.h"

@interface SRFilterReposter()

+(NSPredicate*)_predicateForKeywordsString:(NSString*)keywordsString;

@end

@implementation SRFilterReposter

+(NSArray*)filterFeedItems:(NSArray*)feedItems withFeed:(CDFeed*)feed
{
    NSMutableSet *filteredItemsSet=[NSMutableSet set];
    DLog(@"FILTERS_COUNT %d",feed.filters.count);
    
    if (feed.filters.count)
    {
        for (CDFeedFilter *feedFilter in feed.filters)
        {
            NSPredicate *predicate=[SRFilterReposter _predicateForKeywordsString:feedFilter.keyword];
            predicate=predicate ? predicate : [NSPredicate predicateWithValue:YES];

            NSSet *filteredSet=[feed.items filteredSetUsingPredicate:predicate];
            [filteredItemsSet unionSet:filteredSet];
        }

        DLog(@"FILTERED SET %@",filteredItemsSet);
        return [filteredItemsSet allObjects];
    } else
    {
        return feedItems;
    }
    
    return nil;
}


+(void)repostFeedItems:(NSArray*)feedItems withFeed:(CDFeed*)feed
{
    NSMutableSet *repostFBItemsSet=[NSMutableSet set];
    NSMutableSet *repostTWItemsSet=[NSMutableSet set];
    
    DLog(@"FILTERS_COUNT %d",feed.filters.count);
    
    if (feed.filters.count)
    {
        for (CDFeedFilter *feedFilter in feed.filters)
        {
            NSPredicate *predicate=[SRFilterReposter _predicateForKeywordsString:feedFilter.keyword];
            predicate=predicate ? predicate : [NSPredicate predicateWithValue:NO];

            NSSet *filteredSet=[feed.items filteredSetUsingPredicate:predicate];
                
            if ([feedFilter.repostFB boolValue])
            {
                //adding to repost FB set
                [repostFBItemsSet unionSet:filteredSet];
            }
            if ([feedFilter.repostTW boolValue])
            {
                //adding to repost TW set
                [repostTWItemsSet unionSet:filteredSet];
            }
        }
     
                [SRFBConnect repostFeedItems:[repostFBItemsSet allObjects] withFinishBlock:^(NSUInteger repostedItemsCount)
                 {
                     DLog(@"REPOSTED COUNT %d",repostedItemsCount);
                 }];


        DLog(@"REPOST TO TW COUNT %d",repostTWItemsSet.count);
    [SRTwitterReposter repostFeedItems:[repostTWItemsSet allObjects] withFinishBlock:^(NSUInteger repostedItemsCount)
     {
         DLog(@"REPOSTED_COUNT %d",repostedItemsCount);
     }];
        
        
    }
}


+(NSPredicate*)_predicateForKeywordsString:(NSString*)keywordsString
{
    if (keywordsString)
    {
        NSArray *keywords=keywordsString ? [keywordsString componentsSeparatedByString:@"::"] : [NSArray array];
        NSPredicate *predicate=[NSPredicate predicateWithValue:NO];
        for (NSString *keyword in keywords)
        {
            NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@",keyword];
            NSPredicate *summaryPredicate = [NSPredicate predicateWithFormat:@"summary CONTAINS[cd] %@",keyword];
        
            predicate=[NSCompoundPredicate orPredicateWithSubpredicates:
                                    [NSArray arrayWithObjects:predicate,
                                                              titlePredicate,
                                                              summaryPredicate, nil]];
        }

        return predicate;
    }
    
    return nil;
}


@end
