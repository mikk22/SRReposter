//
//  CDFeedFilter.h
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDFeed;

@interface CDFeedFilter : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSNumber * repostFB;
@property (nonatomic, retain) NSNumber * repostTW;
@property (nonatomic, retain) CDFeed *feed;

@end
