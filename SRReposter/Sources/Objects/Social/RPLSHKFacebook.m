//
//  SRSHKFacebook.m
//  Lova
//
//  Created by user on 19.05.13.
//  Copyright (c) 2013 Novarate. All rights reserved.
//

#import "RPLSHKFacebook.h"
#import "FBSession.h"
#import "FBAccessTokenData.h"

typedef void (^SRAuthFinishBlock)(NSString *token);
typedef void (^SRAuthErrorBlock)(NSError *error);

@interface RPLSHKFacebook ()

@property (nonatomic, copy) SRAuthFinishBlock   authFinishBlock;
@property (nonatomic, copy) SRAuthErrorBlock    authErrorBlock;

@end

@implementation RPLSHKFacebook

+(BOOL)isAuthorized
{
    return FBSession.activeSession.accessTokenData.accessToken ? YES : [SHKFacebook isServiceAuthorized];
}


-(void)authorizeWithFinishBlock:(void(^)(NSString *code))finishBlock errorBlock:(void(^)(NSError *error))errorBlock
{
    if (![self.class isAuthorized])
    {
        self.authFinishBlock=finishBlock ? finishBlock : nil;
        self.authErrorBlock=errorBlock ? errorBlock : nil;
        SHKItem *item = SHKItem.new;
        item.shareType = SHKShareTypeUserInfo;
        SHKFacebook *service = SHKFacebook.new;
        service.shareDelegate=self;
        service.item=item;
        service.quiet=YES;
        
        [service authorize];
    } else
    {
        if (finishBlock)
            finishBlock(FBSession.activeSession.accessTokenData.accessToken);
    }
}





#pragma mark - Facebook methods -


+ (BOOL)handleOpenURL:(NSURL*)url
{
    return [SHKFacebook handleOpenURL:url];
}


+(void)applicationDidBecomeActive
{
    [SHKFacebook handleDidBecomeActive];
}


+(void)applicationWillTerminate
{
    [SHKFacebook handleWillTerminate];
}


#pragma mark - SHKSharerDelegate -


- (void)sharerStartedSending:(SHKSharer *)sharer
{
    DLog(@"VK SHARER START SENDING");
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    DLog(@"VK SHARER FINISHED SENDING");
}


- (void)sharerAuthDidFinish:(SHKSharer *)sharer success:(BOOL)success
{
    DLog(@"SHARER %@",sharer);
    if ([NSStringFromClass([sharer class]) isEqualToString:NSStringFromClass([SHKFacebook class])])
    {
        if (success)
        {
            NSString *accessToken = FBSession.activeSession.accessTokenData.accessToken;
            DLog(@"FB TOKEN %@",accessToken);
            if (self.authFinishBlock)
                self.authFinishBlock(accessToken);
        }
    } else
    {
        NSAssert(NO, @"Unknown CLASS as Sharer Delegate");
    }
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    if (self.authErrorBlock)
        self.authErrorBlock(error);
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    if (self.authErrorBlock)
        self.authErrorBlock(nil);
}

- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    if (self.authErrorBlock)
        self.authErrorBlock(nil);
}

- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    if (self.authErrorBlock)
        self.authErrorBlock(nil);
}






@end
