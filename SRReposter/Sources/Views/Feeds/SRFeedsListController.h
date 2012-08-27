//
//  SRFeedSelectorViewController.h
//  SRReposter
//
//  Created by user on 20.08.12.
//

#import <UIKit/UIKit.h>
#import "SRFeedEditController.h"
#import "SRFeedModel.h"

@interface SRFeedsListController : UITableViewController <JTModelDelegate, SREditDelegate>
{
    SRFeedModel     *_dataSource;
    BOOL            _editMode;
}

@property (nonatomic, strong) SRFeedModel       *dataSource;
@property (nonatomic)         BOOL              editMode;
@end
