//
//  SRFeedFilter.h
//  SRReposter
//
//  Created by user on 24.08.12.
//

#import <Foundation/Foundation.h>
#import "CDFeedFilter.h"

@interface SRFeedFilter : NSObject
{
    NSString    *_name;
    NSArray     *_keywords;
    BOOL        _repostFB;
    BOOL        _repostTW;
}

@property (nonatomic, copy)         NSString    *name;
@property (nonatomic, strong)       NSArray     *keywords;
@property (nonatomic, readwrite)    BOOL        repostFB;
@property (nonatomic, readwrite)    BOOL        repostTW;

+(id)itemNamed:(NSString*)name withKeywords:(NSArray*)keywords repostFB:(BOOL)repostFB repostTW:(BOOL)repostTW;
+(id)filterFromCDFilter:(CDFeedFilter*)cdFeedFilter;

@end
