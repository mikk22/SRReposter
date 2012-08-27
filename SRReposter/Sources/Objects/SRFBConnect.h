//
//  SRFBConnect.h
//  SRReposter
//
//  Created by user on 20.08.12.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SRFBConnect : NSObject

+(void)checkAuthWithFinishBlock:(void(^)(BOOL))finishBlock;
+(void)repostFeedItem:(id)feedItem withFinishBlock:(void(^)(BOOL))finishBlock;
+(void)repostFeedItems:(NSArray*)feedItems withFinishBlock:(void(^)(NSUInteger))finishBlock;

@end
