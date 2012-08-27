//
//  SRFeedModel.m
//  SRReposter
//
//  Created by user on 21.08.12.
//

#import "SRFeedModel.h"
#import "CDFeedFilter.h"
#import "CDFeedItem.h"
#import "SRDatabaseManager.h"

@interface SRFeedModel()
    -(void)_loadModel;
@end

@implementation SRFeedModel


-(void)load
{
    if (!self.isLoading)
    {
        [super load];
        [self _preloadData];
        [self _loadModel];
    }
}


-(void)_preloadData
{
    if(![CDFeed MR_countOfEntities])
    {
        NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
            
        CDFeed *feed=[CDFeed MR_createInContext:localContext];
        feed.name=@"YAHOO NEWS";
        feed.url=@"http://rss.news.yahoo.com/rss/entertainment";


        feed=[CDFeed MR_createInContext:localContext];
        feed.name=@"vmwstudios";
        feed.url=@"http://feeds.feedburner.com/vmwstudios";

        feed=[CDFeed MR_createInContext:localContext];
        feed.name=@"cocoawithlove";
        feed.url=@"http://cocoawithlove.com/feeds/posts/default";

        feed=[CDFeed MR_createInContext:localContext];
        feed.name=@"RayWenderlich";
        feed.url=@"http://feeds.feedburner.com/RayWenderlich";

         feed=[CDFeed MR_createInContext:localContext];
        feed.name=@"maniacdev";
        feed.url=@"http://feeds.feedburner.com/maniacdev";
        
        [localContext MR_save];
    };
    
    
    DLog(@"COUNT %d",[CDFeed MR_countOfEntities]);
}



-(void)_loadModel
{
    _dataObjects=[CDFeed MR_findAll];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES
                                                                    selector:@selector(localizedCaseInsensitiveCompare:)];
    
    _dataObjects=[_dataObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSortDescriptor]];
    [self didLoad];    
}




-(void)addObject:(id)object
{
    NSString *name=[object valueForKey:@"name"] ? [object valueForKey:@"name"] : nil;
    NSString *url=[object valueForKey:@"url"] ? [object valueForKey:@"url"] : nil;

    if (name && url)
    {
        CDFeed *feed=[CDFeed MR_createEntity];
        feed.name=name;
        feed.url=url;
        [feed.managedObjectContext MR_save];
        [super addObject:feed];
    } else
    {
        NSAssert2(NO, @"NAME value can't be NIL URL value can't be NIL. Name is %@ Url is %@",name,url);
    }
}


-(void)updateObject:(id)anObject
{
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
    [super updateObject:anObject];
}


-(void)removeObjectAtIndex:(NSUInteger)index
{
    if (index<self.dataObjects.count)
    {
        [SRDatabaseManager removeFeed:[_dataObjects objectAtIndex:index]];
        [super removeObjectAtIndex:index];
    }
}

-(void)removeObject:(id)anObject
{
    if (anObject)
    {
        [SRDatabaseManager removeFeed:anObject];
        [super removeObject:anObject];
    }
}




-(void)replaceObject:(id)anObject withObject:(id)newObject
{
    SRFeed *newFeedItem=(SRFeed*)newObject;
    NSUInteger objIndex=[_dataObjects indexOfObject:anObject];
    
    CDFeed *feed=[[CDFeed MR_findAll] objectAtIndex:objIndex];
    feed.name=newFeedItem.name;
    feed.url=newFeedItem.url;
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    [super replaceObject:anObject withObject:feed];
}



@end
