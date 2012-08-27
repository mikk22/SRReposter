//
//  SRTwitterReposter.m
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import "SRTwitterReposter.h"

@interface SRTwitterReposter()

+(void)_postFeedItem:(id)feedItem account:(ACAccount*)acct withFinishBlock:(void(^)(BOOL))finishBlock;

@end

@implementation SRTwitterReposter

+(void)repostFeedItem:(id)feedItem withFinishBlock:(void(^)(BOOL))finishBlock
{
    if ([TWTweetComposeViewController canSendTweet]) 
    {
        // Create account store, followed by a twitter account identifier
        // At this point, twitter is the only account type available
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) 
         {
             // Did user allow us access?
             if (granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 
                 // Sanity check
                 if ([arrayOfAccounts count] > 0) 
                 {
                     // Keep it simple, use the first account available
                     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                     
                     [SRTwitterReposter _postFeedItem:feedItem account:acct withFinishBlock:^(BOOL result)
                     {
                         finishBlock(result);
                     }];
                 }
             }
         }];
    } else 
    {
        finishBlock(NO);
    }

}



+(void)repostFeedItems:(NSArray*)feedItems withFinishBlock:(void(^)(NSUInteger))finishBlock
{
    if (feedItems.count)
    {
        __block NSUInteger repostedItemsCount=0;
        __block NSUInteger itemsCount=0;
        for (id feedItem in feedItems)
        {
            [SRTwitterReposter repostFeedItem:feedItem withFinishBlock:^(BOOL result)
             {
                 ++itemsCount;
                 if (result)
                 {
                     ++repostedItemsCount;
                 }
                 
                 if (itemsCount==feedItems.count)
                     finishBlock(repostedItemsCount);
             }];
        }
    } else
    {
        finishBlock(0);
    }
}






+(void)_postFeedItem:(id)feedItem account:(ACAccount*)acct withFinishBlock:(void(^)(BOOL))finishBlock
{
    NSString *title=[feedItem valueForKey:@"title"] ? [feedItem valueForKey:@"title"] : nil;
    NSString *link=[feedItem valueForKey:@"link"] ? [feedItem valueForKey:@"link"] : nil;
    
    if (title && link)
    {
        NSString *postString=[NSString stringWithFormat:@"%@ %@",title,link];
        NSDictionary *postDictionary=[NSDictionary dictionaryWithObject:postString forKey:@"status"];
        
        // Build a twitter request
        TWRequest *postRequest = [[TWRequest alloc] initWithURL:
                                  [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
                                                     parameters:postDictionary
                                                  requestMethod:TWRequestMethodPOST];
        
        // Post the request
        [postRequest setAccount:acct];
        
        // Block handler to manage the response
        [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
         {
             DLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
             if ([urlResponse statusCode]==200)
                 finishBlock(YES);
             else
                 finishBlock(NO);
         }];
    } else
    {
        finishBlock(NO);
    }
}

@end
