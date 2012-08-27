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

@synthesize feed=_feed;

-(void)dealloc
{
    self.feed=nil;
}

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
    [[feedFilter managedObjectContext] MR_save];
    [super addObject:feedFilter];
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
        [[_dataObjects objectAtIndex:index] MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_save];
        [super removeObjectAtIndex:index];
    }
}

-(void)removeObject:(id)anObject
{
    if ([anObject isKindOfClass:[NSManagedObject class]])
    {
        [((NSManagedObject*)anObject) MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_save];
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
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    [super replaceObject:anObject withObject:feedFilter];
}


@end
