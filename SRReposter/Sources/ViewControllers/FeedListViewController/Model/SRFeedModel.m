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
-(NSArray*)_loadDefaultFeedList;

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


-(NSArray*)_loadDefaultFeedList
{
    NSString *plistFile = [NSBundle.mainBundle.resourcePath
                           stringByAppendingPathComponent:@"defaultFeedList.plist"];
    
    return [NSArray arrayWithContentsOfFile:plistFile];
}

-(void)_preloadData
{
    if(![CDFeed MR_countOfEntities])
    {
        NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];

        NSArray *defaultFeedList=[self _loadDefaultFeedList];
        DLog(@"DEFAULT FEED LIST %@",defaultFeedList);
        
        for (NSDictionary *feedItem in defaultFeedList)
        {
            if ([feedItem objectForKey:@"Name"] && [feedItem objectForKey:@"Url"])
            {
                CDFeed *feed=[CDFeed MR_createInContext:localContext];
                feed.name=[feedItem objectForKey:@"Name"];
                feed.url=[feedItem objectForKey:@"Url"];
            }
        }
        
        [localContext MR_saveToPersistentStoreAndWait];
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
        [feed.managedObjectContext MR_saveToPersistentStoreAndWait];
        [super addObject:feed];
    } else
    {
        NSAssert2(NO, @"NAME value can't be NIL URL value can't be NIL. Name is %@ Url is %@",name,url);
    }
}


-(void)updateObject:(id)anObject
{
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
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
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [super replaceObject:anObject withObject:feed];
}



@end
