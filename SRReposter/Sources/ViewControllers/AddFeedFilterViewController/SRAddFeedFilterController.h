//
//  SRAddFeedFilterController.h
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import <UIKit/UIKit.h>
#import "SRFeedFilter.h"
#import "CDFeedFilter.h"
#import "SREditProtocol.h"

enum
{
    SRFilterNameSection   = 0,
    SRFilterKeywordsSection,
    SRFilterRepostSection,
    SRFilterSectionsCount
};


@interface SRAddFeedFilterController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    __weak  id<SREditDelegate>      _delegate;
    CDFeedFilter                    *_feedFilter;
    
}

@property (nonatomic, strong)   CDFeedFilter            *feedFilter;
@property (nonatomic, weak)     id<SREditDelegate>      delegate;

- (id)initWithEditMode:(SREditMode)editMode;


@end
