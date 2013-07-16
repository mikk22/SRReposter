//
//  SRReposterDefines.h
//  SRReposter
//
//  Created by user on 18.08.12.
//

#import "SRReposterMacros.h"

#define TITLE_FONT          [UIFont boldSystemFontOfSize:19.f]
#define DEFAULT_FONT        [UIFont systemFontOfSize:17.f]
#define CELL_LEFT_OFFSET    7.f


#define     FEED_ITEMS_CD_LIMIT 100
#define     DEFAULT_FEEDLIST_FILENAME   @"defaultFeedList.plist"
#define     DEFAULT_DATABASE_FILENAME   @"Database.sqlite"

typedef enum
{
    SRModeAdd   = 0,
    SRModeEdit  = 1
} SREditMode;
