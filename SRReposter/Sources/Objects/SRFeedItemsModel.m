//
//  SRFeedItemsModel.m
//  SRReposter
//
//

#import "SRFeedItemsModel.h"
#import "SRFilterReposter.h"

@interface SRFeedItemsModel()
{
    NSMutableArray  *_parsedItems;
}

@property (nonatomic, strong)   CDFeed  *feed;

@end

@implementation SRFeedItemsModel

@synthesize feed=_feed;

-(void)dealloc
{
    self.feed=nil;
    _parsedItems=nil;
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
    _dataObjects=[SRDatabaseManager findLastFeedItemsWithFeed:self.feed limitTo:FEED_ITEMS_CD_LIMIT];
    _dataObjects=[SRFilterReposter filterFeedItems:_dataObjects withFeed:self.feed];
    
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO
                                                                    selector:@selector(compare:)];
    _dataObjects=[_dataObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
    
    //repost to FB and TW
    [SRFilterReposter repostFeedItems:_dataObjects withFeed:self.feed];

    
    [self didLoad];
}











#pragma mark -
#pragma mark Parsing

// Reset and reparse


-(void)refresh
{
    //reloads only new items from URLS
    //and say's about it to its delegate
    _parsedItems = [NSMutableArray array];
    
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:[NSURL URLWithString:self.feed.url]];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
}








#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	//NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	//NSLog(@"Parsed Feed Info: “%@”", info.title);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
//	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item)
        [_parsedItems addObject:item];
}




-(void)_parserDidFinish
{
    NSArray *newItems=[SRDatabaseManager addFeedItems:_parsedItems withFeed:self.feed];
   
    NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO
                                                                        selector:@selector(compare:)];
    newItems=[newItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
    _dataObjects=[newItems arrayByAddingObjectsFromArray:_dataObjects];
    
    DLog(@"PARSED %d NEW %d",_parsedItems.count,newItems.count);
    
    
    
    //repost to FB and TW
    [SRFilterReposter repostFeedItems:newItems withFeed:self.feed];
    [self changedWithItems:newItems];
    _parsedItems=nil;
}




- (void)feedParserDidFinish:(MWFeedParser *)parser
{
	//NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self _parserDidFinish];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	DLog(@"Finished Parsing With Error: %@", error);
    [self _parserDidFinish];
}

@end
