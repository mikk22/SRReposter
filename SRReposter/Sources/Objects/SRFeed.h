//
//  SRFeedItem.h
//  SRReposter
//
//  Created by user on 20.08.12.
//

#import <Foundation/Foundation.h>

@interface SRFeed : NSObject
{
    NSString    *_name;
    NSString    *_url;
}

@property (nonatomic, copy)   NSString    *name;
@property (nonatomic, copy)   NSString    *url;

+(SRFeed*)itemNamed:(NSString*)name withUrl:(NSString*)urlString;

@end
