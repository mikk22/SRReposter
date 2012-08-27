//
//  CDFeedItem.h
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDFeed;

@interface CDFeedItem : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * postedFB;
@property (nonatomic, retain) NSNumber * postedTW;
@property (nonatomic, retain) CDFeed *feed;

@end
