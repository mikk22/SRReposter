//
//  SRFeedItem.h
//  SRReposter
//
//  Created by user on 18.08.12.
//  Copyright (c) 2012 Intelvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRFeedItem : NSObject
{
    NSString    *_blogTitle;
    NSString    *_articleTitle;
    NSString    *_articleUrl;
    NSDate      *_articleDate;
}

@property (copy) NSString   *blogTitle;
@property (copy) NSString   *articleTitle;
@property (copy) NSString   *articleUrl;
@property (copy) NSDate     *articleDate;

+ (SRFeedItem*)itemWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate;


@end
