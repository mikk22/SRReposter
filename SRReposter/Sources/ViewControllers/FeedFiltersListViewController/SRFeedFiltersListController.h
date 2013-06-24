//
//  SRFeedFiltersListController.h
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import <UIKit/UIKit.h>
#import "SRFeedFiltersModel.h"
#import "CDFeed.h"
#import "CDFeedFilter.h"
#import "SREditProtocol.h"

@protocol SRFeedFiltersListDelegate <NSObject>
-(void)filtersListUpdated;

@end

@interface SRFeedFiltersListController : UITableViewController <JTModelDelegate, SREditDelegate>
{
    __weak id<SRFeedFiltersListDelegate>    _delegate;
    CDFeed                                  *_feed;
    SRFeedFiltersModel                      *_dataSource;
}

@property (nonatomic, weak)     id<SRFeedFiltersListDelegate>       delegate;
@property (nonatomic, strong)   CDFeed                              *feed;
@property (nonatomic, strong)   SRFeedFiltersModel                  *dataSource;


-(id)initWithFeed:(CDFeed*)feed;


@end
