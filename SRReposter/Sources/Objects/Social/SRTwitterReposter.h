//
//  SRTwitterReposter.h
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface SRTwitterReposter : NSObject

+(void)repostFeedItem:(id)feedItem withFinishBlock:(void(^)(BOOL))finishBlock;
+(void)repostFeedItems:(NSArray*)feedItems withFinishBlock:(void(^)(NSUInteger))finishBlock;

@end
