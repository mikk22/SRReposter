//
//  SRFeedFiltersModel.h
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import "JTModel.h"
#import "CDFeed.h"
#import "CDFeedFilter.h"
#import "SRFeedFilter.h"

@interface SRFeedFiltersModel : JTModel

-(id)initWithFeed:(CDFeed*)feed;

@end
