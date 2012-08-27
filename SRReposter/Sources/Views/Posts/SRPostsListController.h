//
//  SRFeedViewController.h
//  SRReposter
//
//  Created by user on 18.08.12.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SRFeedItemsModel.h"
#import "CDFeed.h"
#import "SRFeedFiltersListController.h"

@interface SRPostsListController : UITableViewController <JTModelDelegate,
                                                         SRFeedFiltersListDelegate,
                                                         EGORefreshTableHeaderDelegate
                                                        >
{
	EGORefreshTableHeaderView *_refreshHeaderView;
}

-(id)initWithFeed:(CDFeed*)feed;

@end
