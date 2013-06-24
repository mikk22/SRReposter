//
//  SRFeedItemsModel.h
//  SRReposter
//
//

#import "JTModel.h"
#import "SRDatabaseManager.h"
#import "MWFeedParser.h"
#import "SRFeed.h"
#import "CDFeed.h"

@interface SRFeedItemsModel : JTModel <MWFeedParserDelegate>

-(id)initWithFeed:(CDFeed*)feed;
-(void)refresh;

@end
