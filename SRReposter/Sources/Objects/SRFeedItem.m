//
//  SRFeedItem.m
//  SRReposter
//
//  Created by user on 18.08.12.
//  Copyright (c) 2012 Intelvision. All rights reserved.
//

#import "SRFeedItem.h"

@implementation SRFeedItem

@synthesize blogTitle = _blogTitle;
@synthesize articleTitle = _articleTitle;
@synthesize articleUrl = _articleUrl;
@synthesize articleDate = _articleDate;

- (void)dealloc
{
    self.blogTitle = nil;
    self.articleTitle = nil;
    self.articleUrl = nil;
    self.articleDate = nil;
}


+ (SRFeedItem*)itemWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate;
{
    SRFeedItem *feedItem=[[SRFeedItem alloc] init];
    if (feedItem)
    {
        feedItem.blogTitle = blogTitle;;
        feedItem.articleTitle= articleTitle;
        feedItem.articleUrl=articleUrl;
        feedItem.articleDate=articleDate;
    }
    return feedItem;
}





-(NSString*)description
{
    NSDictionary *dictionary=[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:
                                                                @"blogTitle",
                                                                @"articleTitle",
                                                                @"articleUrl",
                                                                @"articleDate",
                                                                nil] ];
    return [NSString stringWithFormat:@"%@",dictionary];
}




@end
