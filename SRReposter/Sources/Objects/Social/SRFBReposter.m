//
//  SRFBConnect.m
//  SRReposter
//
//  Created by user on 20.08.12.
//

#import "SRFBReposter.h"
#import "RPLSHKFacebook.h"
#import "FacebookSDK.h"


@interface SRFBReposter()

+(NSDictionary*)_fbPostParamsFromFeedItem:(id)feedItem;

@end

@implementation SRFBReposter

-(void)repostFeedItem:(id)feedItem withFinishBlock:(void(^)(BOOL))finishBlock
{
    if ([RPLSHKFacebook isAuthorized])
    {
        NSDictionary *postParams=[SRFBReposter _fbPostParamsFromFeedItem:feedItem];
        
        if (!FBSession.activeSession.isOpen) {
            [FBSession openActiveSessionWithAllowLoginUI: YES];
        }
        [FBRequestConnection startWithGraphPath:@"me/feed" parameters:postParams HTTPMethod:@"POST" completionHandler:
         ^(FBRequestConnection *connection, id result,NSError *error)
         {
             NSString *alertText;
             if (error)
             {
                 alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d, description %@", error.domain, error.code, error.description];
                 finishBlock(NO);
             } else
             {
                 alertText = [NSString stringWithFormat:@"Posted action, id: %@",[result objectForKey:@"id"]];
                 finishBlock(YES);
             }
             // Show the result in an alert
             
             DLog(@"POST_MESSAGE: %@",alertText);
         }];
    }
}




-(void)repostFeedItems:(NSArray*)feedItems withFinishBlock:(void(^)(NSUInteger))finishBlock
{
    if (feedItems.count)
    {
        if ([RPLSHKFacebook isAuthorized])
        {
            if (!FBSession.activeSession.isOpen) {
                [FBSession openActiveSessionWithAllowLoginUI: YES];
            }
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            
            __block NSUInteger  itemsCompleted=0;
            __block NSUInteger  itemsPosted=0;
            
            for (id feedItem in feedItems)
            {
                NSDictionary *postParams=[SRFBReposter _fbPostParamsFromFeedItem:feedItem];
                
                FBRequest *request =
                [FBRequest requestWithGraphPath:@"me/feed"
                                     parameters:postParams
                                     HTTPMethod:@"POST"];
                
                [connection addRequest:request completionHandler:
                 ^(FBRequestConnection *connection, id result, NSError *error)
                 {
                     ++itemsCompleted;
                     
                     
                     NSString *alertText;
                     if (error)
                     {
                         alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d", error.domain, error.code];
                     } else
                     {
                         ++itemsPosted;
                         alertText = [NSString stringWithFormat:@"Posted action, id: %@",[result objectForKey:@"id"]];
                     }
                     // Show the result in an alert
                     
                     DLog(@"POST_MESSAGE: %@",alertText);
                     
                     if (itemsCompleted==feedItems.count)
                     {
                         finishBlock(itemsPosted);
                     }
                     
                 }];
            }
            
            [connection start];
        };
    } else
    {
        finishBlock(0);
    }
}


+(NSDictionary*)_fbPostParamsFromFeedItem:(id)feedItem
{
    NSString *title=[feedItem valueForKey:@"title"] ? [feedItem valueForKey:@"title"] : nil;
    NSString *link=[feedItem valueForKey:@"link"] ? [feedItem valueForKey:@"link"] : nil;
    NSString *summary=[feedItem valueForKey:@"summary"] ? [feedItem valueForKey:@"summary"] : nil;
    
    if (summary && summary.length>=1000)
        summary=[summary substringToIndex:1000];
    
    //NSString *content=[feedItem valueForKey:@"content"] ? [feedItem valueForKey:@"content"] : nil;
    
    NSDictionary *postParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     link, @"link",
     @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
     title, @"name",
     summary, @"caption",
     //content, @"description",
     nil];

    return postParams;
}


@end
