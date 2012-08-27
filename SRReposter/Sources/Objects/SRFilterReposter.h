//
//  SRFilterReposter.h
//  SRReposter
//
//  Created by user on 25.08.12.
//

#import <Foundation/Foundation.h>
#import "CDFeed.h"

@interface SRFilterReposter : NSObject

+(NSArray*)filterFeedItems:(NSArray*)feedItems withFeed:(CDFeed*)feed;
+(void)repostFeedItems:(NSArray*)feedItems withFeed:(CDFeed*)feed;

@end
