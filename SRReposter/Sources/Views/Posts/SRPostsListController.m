//
//  SRFeedViewController.m
//  SRReposter
//
//  Created by user on 18.08.12.
//

#import "SRPostsListController.h"

#import "NSArray+Extras.h"
#import "SRPostWebViewController.h"
#import "SRPostInfoViewController.h"

#import "NSString+HTML.h"


@interface SRPostsListController ()
{
    CDFeed  *_feed;
    SRFeedItemsModel    *_feedItems;
}

@property (nonatomic, strong)   SRFeedItemsModel    *feedItems;
@property (nonatomic, strong)   CDFeed              *feed;

-(void)_setupNavigationBar;

//buttons touches
-(void)_buttonSetupFeedFiltersTouch:(id)sender;

@end

@implementation SRPostsListController

@synthesize feedItems=_feedItems;
@synthesize feed=_feed;

-(void)dealloc
{
    self.feed=nil;
    self.feedItems=nil;
}


-(id)initWithFeed:(CDFeed*)feed
{
    self=[super init];
    if (self)
    {
        self.feed=feed;
        DLog(@"FEED %@",self.feed);
    }
    
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupNavigationBar];
    
    self.feedItems=[[SRFeedItemsModel alloc] initWithFeed:self.feed];
    self.feedItems.delegate=self;
    [self.feedItems load];

	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}






-(void)_setupNavigationBar
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(_buttonSetupFeedFiltersTouch:)];
}



#pragma mark - Button Touches -


-(void)_buttonSetupFeedFiltersTouch:(id)sender
{
    SRFeedFiltersListController *feedFiltersListController=[[SRFeedFiltersListController alloc] initWithFeed:self.feed];
    feedFiltersListController.delegate=self;
    [self.navigationController pushViewController:feedFiltersListController animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedItems.dataObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	// Configure the cell.
	CDFeedItem *item = [self.feedItems.dataObjects objectAtIndex:indexPath.row];
    
	if (item) {
		
		// Process
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
		
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
		// Set
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.textLabel.text = itemTitle;
		NSMutableString *subtitle = [NSMutableString string];
		if (item.date) [subtitle appendFormat:@"%@: ", [formatter stringFromDate:item.date]];
		[subtitle appendString:itemSummary];
		cell.detailTextLabel.text = subtitle;
		
	}
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

	CDFeedItem *item = [self.feedItems.dataObjects objectAtIndex:indexPath.row];
    
    SRPostInfoViewController *postInfoController=[[SRPostInfoViewController alloc] initWithStyle:UITableViewStylePlain];
    postInfoController.feedItem=item;
    [self.navigationController pushViewController:postInfoController animated:YES];
}


#pragma mark - JTModel Delegate -

-(void)modelDidLoad:(JTModel*)model
{
    if ([model isEqual:self.feedItems])
    {
        [self.feedItems refresh];
        [self.tableView reloadData];
    }
}

-(void)modelChanged:(JTModel *)model withItems:(NSArray *)newItems
{
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    if (newItems.count)
    {
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:
                                                ((newItems.count==self.feedItems.dataObjects.count) ? (newItems.count-1) : newItems.count) inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}














#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	
	[self.feedItems refresh];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.feedItems.isLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark - SRFeedFiltersList Delegate -

-(void)filtersListUpdated
{
    [self.feedItems load];
}





@end
