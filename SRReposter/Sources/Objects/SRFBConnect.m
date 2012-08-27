//
//  SRFBConnect.m
//  SRReposter
//
//  Created by user on 20.08.12.
//

#import "SRFBConnect.h"

@interface SRFBConnect()

+(NSDictionary*)_fbPostParamsFromFeedItem:(id)feedItem;

@end

@implementation SRFBConnect



+(void)checkAuthWithFinishBlock:(void(^)(BOOL))finishBlock
{
    //session block
    FBSessionStateHandler _sessionStateChanged=^(FBSession *session, FBSessionState state, NSError *error)
    {
        switch (state)
        {
            case FBSessionStateOpen:
            {
                DLog(@"SESSION_OPENED");
                finishBlock(YES);
                break;
            }
            case FBSessionStateClosed:
            case FBSessionStateClosedLoginFailed:
                
                DLog(@"!!!SESSION CLOSED");
                
                [session closeAndClearTokenInformation];
                finishBlock(NO);
                break;
            default:
                // Once the user has logged in, we want them to 
                // be looking at the root view.
                //[self.navController popToRootViewControllerAnimated:NO];
                
                break;
        }
        
        if (error)
        {
            DLog(@"Error: %@",error.localizedDescription);
            finishBlock(NO);
        }    
    };
    
    
    //main body
    
    
    // See if we have a valid token for the current state.
    DLog(@"STATE %d",FBSession.activeSession.state);
    
    switch (FBSession.activeSession.state)
    {
        case FBSessionStateOpenTokenExtended:
        case FBSessionStateOpen:
        {
            DLog(@"SESSION STATE OPEN");
            finishBlock(YES);
            return;
        }
        case FBSessionStateCreatedTokenLoaded:
        {
            DLog(@"SESSION FBSessionStateCreatedTokenLoaded");
            [FBSession.activeSession openWithCompletionHandler:_sessionStateChanged];
            break;
        }
        default:
        {
            DLog(@"!!!NO_SESSION");
            
            //opening new session
            NSArray *permissions = [[NSArray alloc] initWithObjects:
                                    @"publish_actions",
                                    @"read_stream",
                                    nil];
            
            [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:_sessionStateChanged]; 
            break;
        }    
    }
}








//logout
-(void)logoutButtonWasPressed:(id)sender
{
    //[FBSession.activeSession close];
    [FBSession.activeSession closeAndClearTokenInformation];
}



+(void)repostFeedItem:(id)feedItem withFinishBlock:(void(^)(BOOL))finishBlock
{
    [SRFBConnect checkAuthWithFinishBlock:^(BOOL result)
     {
         if (result)
         {
             NSDictionary *postParams=[SRFBConnect _fbPostParamsFromFeedItem:feedItem];
             
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
     }];
}




+(void)repostFeedItems:(NSArray*)feedItems withFinishBlock:(void(^)(NSUInteger))finishBlock
{
    if (feedItems.count)
    {
        [SRFBConnect checkAuthWithFinishBlock:^(BOOL result)
         {
             if (result)
             {
                 
                 FBRequestConnection *connection = [[FBRequestConnection alloc] init];
                 
                 __block NSUInteger  itemsCompleted=0;
                 __block NSUInteger  itemsPosted=0;
                 
                 for (id feedItem in feedItems)
                 {
                     NSDictionary *postParams=[SRFBConnect _fbPostParamsFromFeedItem:feedItem];
                     
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
         }];
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
