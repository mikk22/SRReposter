//
//  SRFeedFiltersModel.m
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import "SRFeedFiltersModel.h"

@interface SRFeedFiltersModel()
@property (nonatomic, strong)   CDFeed  *feed;
@end


@implementation SRFeedFiltersModel

-(id)initWithFeed:(CDFeed*)feed
{
    self=[super init];
    if (self)
    {
        self.feed=feed;
    }
    
    return self;
}



-(void)load
{
    if (!self.isLoading)
    {
        [super load];
        [self _loadModel];
    }
}


-(void)_loadModel
{
    _dataObjects=[CDFeedFilter MR_findByAttribute:@"feed" withValue:self.feed];
    [self didLoad];
}


-(void)addObject:(id)object
{
    CDFeedFilter *feedFilter=(CDFeedFilter*)object;//[CDFeedFilter MR_createEntity];
    feedFilter.feed=self.feed;
    [[feedFilter managedObjectContext] MR_saveToPersistentStoreAndWait];
    [super addObject:feedFilter];
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
        [[_dataObjects objectAtIndex:index] MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [super removeObjectAtIndex:index];
    }
}

-(void)removeObject:(id)anObject
{
    if ([anObject isKindOfClass:[NSManagedObject class]])
    {
        [((NSManagedObject*)anObject) MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [super removeObject:anObject];
    }
}


-(void)replaceObject:(id)anObject withObject:(id)newObject
{
    SRFeedFilter *newFeedFilter=(SRFeedFilter*)newObject;
    NSUInteger objIndex=[_dataObjects indexOfObject:anObject];
    
    CDFeedFilter *feedFilter=[[CDFeedFilter MR_findAll] objectAtIndex:objIndex];

    feedFilter.name=newFeedFilter.name;
    feedFilter.repostFB=[NSNumber numberWithBool:newFeedFilter.repostFB];
    feedFilter.repostTW=[NSNumber numberWithBool:newFeedFilter.repostTW];
    feedFilter.keyword=[newFeedFilter.keywords componentsJoinedByString:@"::"];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [super replaceObject:anObject withObject:feedFilter];
}


@end
