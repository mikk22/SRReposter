//
//  SRaddFeedViewController.h
//  SRReposter
//

#import <UIKit/UIKit.h>
#import "SRFeed.h"
#import "CDFeed.h"
#import "SREditProtocol.h"

@interface SRFeedEditController : UITableViewController <UITextFieldDelegate>
{
    __weak  id<SREditDelegate>      _delegate;
    CDFeed                          *_feedItem;
    
}

@property (nonatomic, strong)   CDFeed                  *feedItem;
@property (nonatomic, weak)     id<SREditDelegate>      delegate;

- (id)initWithEditMode:(SREditMode)editMode;


@end
