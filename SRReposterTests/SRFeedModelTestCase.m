//
//  SRFeedModel_Tests.m
//  SRReposter
//
//  Created by user on 26.08.12.
//

#define TEST_OBJECTS_ARRAY      [NSArray arrayWithObjects:\
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"Yahoo news",       @"name", @"http://rss.news.yahoo.com/rss/entertainment",    @"url", nil],\
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"vmwstudios",       @"name", @"http://feeds.feedburner.com/vmwstudio",          @"url", nil],\
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"cocoawithlove",    @"name", @"http://cocoawithlove.com/feeds/posts/default",   @"url", nil],\
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"RayWenderlich",    @"name", @"http://feeds.feedburner.com/RayWenderlich",      @"url", nil],\
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"maniacdev",        @"name", @"http://feeds.feedburner.com/maniacdev",          @"url", nil],\
                                nil]


#import "SRFeedModelTestCase.h"

typedef enum
{
    kTCLoadModel=1,
    kTCAddObject,
    kTCUpdateObject

} testIdentifier;


@interface SRFeedModelTestCase ()
{
    SRFeedModel     *feedModel;
    testIdentifier  _testIdentifier;
}

@end

@implementation SRFeedModelTestCase

- (void)setUp
{
    [super setUp];
    //setting up core data stack for test purposes
    [MagicalRecord cleanUp];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    //creating model
    feedModel=[[SRFeedModel alloc] init];
    feedModel.delegate=self;
}

- (void)tearDown
{
    feedModel=nil;
    [MagicalRecord cleanUp];
    [super tearDown];

}

-(void)testAddObject
{
    _testIdentifier=kTCAddObject;
    NSDictionary *newItem=[TEST_OBJECTS_ARRAY objectAtIndex:0];
    [feedModel addObject:newItem];
}


- (void)testLoadModel
{
    //clearing CD from previous test
    [MagicalRecord cleanUp];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    _testIdentifier=kTCLoadModel;

    //preloading some data directly
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    
    
    CDFeed *feed;
    for (NSUInteger index=0; index<5; ++index)
    {
        NSDictionary *newItem=[TEST_OBJECTS_ARRAY objectAtIndex:index];
        feed=[CDFeed MR_createInContext:localContext];
        feed.name=[newItem objectForKey:@"name"];
        feed.url=[newItem objectForKey:@"url"];
    }
    
    [localContext MR_save];

    //assume we load these 5 records from local storage
    [feedModel load];
}

/*
 -(void)updateObject:(id)anObject
-(void)removeObjectAtIndex:(NSUInteger)index
-(void)removeObject:(id)anObject
-(void)replaceObject:(id)anObject withObject:(id)newObject
*/


#pragma mark - JTModel Delegate -

-(void)modelChanged:(JTModel*)model
{
    switch (_testIdentifier)
    {
        case kTCAddObject:
        {
            NSDictionary *item=[TEST_OBJECTS_ARRAY objectAtIndex:0];
            STAssertTrue(feedModel.dataObjects.count==1, @"We added only 1 object to CD Database. But received %d",feedModel.dataObjects.count);
            //getting object
            id receivedObject=[feedModel.dataObjects lastObject];
            
            NSString *name=[receivedObject valueForKey:@"name"];
            NSString *url=[receivedObject valueForKey:@"url"];
            STAssertTrue([name isEqualToString:[item objectForKey:@"name"]], @"We added object with name %@. Received %@",[item objectForKey:@"name"],name);
            STAssertTrue([url isEqualToString:[item objectForKey:@"url"]], @"We added object with url %@. Received %@",[item objectForKey:@"url"],url);
            break;
        }
        case kTCLoadModel:
        {
            STAssertTrue(feedModel.dataObjects.count==5, @"We added 5 objects to CD Database. But received %d",feedModel.dataObjects.count);
            
            //we must load 5 items
            for (NSUInteger index=0; index<5; ++index)
            {
                NSDictionary *item=[TEST_OBJECTS_ARRAY objectAtIndex:index];
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name == %@",[item objectForKey:@"name"]];
                id receivedObject=[[feedModel.dataObjects filteredArrayUsingPredicate:predicate] lastObject];
                STAssertNotNil(receivedObject, @"Object after find can't be NIL. It means we can't load object.");
                
                NSString *name=[receivedObject valueForKey:@"name"];
                NSString *url=[receivedObject valueForKey:@"url"];
                STAssertTrue([name isEqualToString:[item objectForKey:@"name"]], @"We added object with name %@. Received %@",[item objectForKey:@"name"],name);
                STAssertTrue([url isEqualToString:[item objectForKey:@"url"]], @"We added object with url %@. Received %@",[item objectForKey:@"url"],url);
            }
            break;
        }
        default:
            break;
    }
    
    
//        [self.tableView reloadData];
}


@end
