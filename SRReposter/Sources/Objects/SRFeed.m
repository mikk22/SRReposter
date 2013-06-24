//
//  SRFeedItem.m
//  SRReposter
//
//  Created by user on 20.08.12.
//

#import "SRFeed.h"

@implementation SRFeed

+(SRFeed*)itemNamed:(NSString*)name withUrl:(NSString*)urlString
{
    SRFeed *item=SRFeed.new;
    if (item)
    {
        item.name=name;
        item.url=urlString;
    }
    
    return item;
}






-(NSString*)description
{
    NSDictionary *dictionary=[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:
                                                                @"name",
                                                                @"url",
                                                                nil] ];
    return [NSString stringWithFormat:@"%@",dictionary];
}


@end
