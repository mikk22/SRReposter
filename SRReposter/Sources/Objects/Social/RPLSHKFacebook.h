//
//  SRSHKFacebook.h
//  Lova
//
//  Created by user on 19.05.13.
//  Copyright (c) 2013 Novarate. All rights reserved.
//

#import "SHKFacebook.h"

@interface RPLSHKFacebook : SHKFacebook <SHKSharerDelegate>

+(BOOL)isAuthorized;
-(void)authorizeWithFinishBlock:(void(^)(NSString *code))finishBlock errorBlock:(void(^)(NSError *error))errorBlock;
//
+ (BOOL)handleOpenURL:(NSURL*)url;
+(void)applicationDidBecomeActive;
+(void)applicationWillTerminate;

@end
