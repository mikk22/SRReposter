//
//  SRFeedFilter.m
//  SRReposter
//
//  Created by user on 24.08.12.
//

#import "SRFeedFilter.h"

@implementation SRFeedFilter

@synthesize name=_name;
@synthesize keywords=_keywords;
@synthesize repostFB=_repostFB;
@synthesize repostTW=_repostTW;

-(NSArray*)keywords
{
if (!_keywords)
    _keywords=[NSArray array];
    
    return _keywords;
}

+(id)itemNamed:(NSString*)name withKeywords:(NSArray*)keywords repostFB:(BOOL)repostFB repostTW:(BOOL)repostTW
{
    SRFeedFilter *feedFilter=[[SRFeedFilter alloc] init];
    if (feedFilter)
    {
        feedFilter.name=name;
        feedFilter.repostFB=repostFB;
        feedFilter.repostTW=repostTW;
        feedFilter.keywords=keywords;
    }
    
    return feedFilter;
}


+(id)filterFromCDFilter:(CDFeedFilter*)cdFeedFilter
{
    SRFeedFilter *feedFilter=[[SRFeedFilter alloc] init];
    if (feedFilter)
    {
        feedFilter.name=cdFeedFilter.name;
        feedFilter.repostFB=[cdFeedFilter.repostFB boolValue];
        feedFilter.repostTW=[cdFeedFilter.repostTW boolValue];
        feedFilter.keywords=[cdFeedFilter.keyword componentsSeparatedByString:@"::"];
    }
    
    return feedFilter;
}

@end
