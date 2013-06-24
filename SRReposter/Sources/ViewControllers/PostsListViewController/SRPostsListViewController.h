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

@interface SRPostsListViewController : UITableViewController <JTModelDelegate,
                                                         SRFeedFiltersListDelegate,
                                                         EGORefreshTableHeaderDelegate
                                                        >

-(id)initWithFeed:(CDFeed*)feed;

@end
