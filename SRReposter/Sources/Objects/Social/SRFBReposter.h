//
//  SRFBConnect.h
//  SRReposter
//
//  Created by user on 20.08.12.
//

#import <Foundation/Foundation.h>

@interface SRFBReposter : NSObject

-(void)repostFeedItem:(id)feedItem withFinishBlock:(void(^)(BOOL))finishBlock;
-(void)repostFeedItems:(NSArray*)feedItems withFinishBlock:(void(^)(NSUInteger))finishBlock;

@end
