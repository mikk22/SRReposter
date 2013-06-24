//
//  SRaddFeedViewController.h
//  SRReposter
//

#import <UIKit/UIKit.h>
#import "SRFeed.h"
#import "CDFeed.h"
#import "SREditProtocol.h"

@interface SREditFeedViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong)   CDFeed                  *feedItem;
@property (nonatomic, weak)     id<SREditDelegate>      delegate;

- (id)initWithEditMode:(SREditMode)editMode;


@end
