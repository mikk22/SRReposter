//
//  SRFeedFiltersListController.m
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import "SRFeedFiltersListController.h"
#import "SRAddFeedFilterController.h"


@interface SRFeedFiltersListController ()
-(void)_addNewFeedFilterButtonTouch:(id)sender;
@end

@implementation SRFeedFiltersListController

@synthesize feed=_feed;
@synthesize delegate;

-(void)dealloc
{
    self.feed=nil;
}


-(id)initWithFeed:(CDFeed*)feed
{
    self=[super init];
    if (self)
    {
        self.feed=feed;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupNavigationBar];
    
    self.dataSource=[[SRFeedFiltersModel alloc] initWithFeed:self.feed];
    self.dataSource.delegate=self;
    [self.dataSource load];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




-(void)_setupNavigationBar
{
    self.navigationItem.title=NSLocalizedString(@"[Feed filters]", nil);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_addNewFeedFilterButtonTouch:)];
}


#pragma mark - Buttons Touches -

-(void)_addNewFeedFilterButtonTouch:(id)sender
{
    SRAddFeedFilterController *addFeedFilterController=[[SRAddFeedFilterController alloc] initWithEditMode:SRModeAdd];
    addFeedFilterController.delegate=self;
    UINavigationController  *navigationController=[[UINavigationController alloc] initWithRootViewController:addFeedFilterController];
    [self.navigationController presentModalViewController:navigationController animated:YES];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.dataObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text=[[self.dataSource.dataObjects objectAtIndex:indexPath.row] name];
    
    return cell;
}

#pragma mark - Table view delegate


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [self.delegate filtersListUpdated];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SRAddFeedFilterController *addFeedFilterController=[[SRAddFeedFilterController alloc] initWithEditMode:SRModeEdit];
    addFeedFilterController.delegate=self;
    addFeedFilterController.feedFilter=[self.dataSource.dataObjects objectAtIndex:indexPath.row];
    UINavigationController  *navigationController=[[UINavigationController alloc] initWithRootViewController:addFeedFilterController];
    [self.navigationController presentModalViewController:navigationController animated:YES];
}





#pragma mark - JTModel Delegate -

-(void)modelChanged:(JTModel*)model
{
    if ([model isEqual:self.dataSource])
    {
        [self.tableView reloadData];
    }
}




#pragma mark - SREdit Delegate -
-(void)updateItem:(id)anObject
{
    [self.dataSource updateObject:anObject];
    [self.tableView reloadData];
    [self.delegate filtersListUpdated];
}

-(void)addItem:(id)newItem
{
    SRFeedFilter* newFeedFilter=(SRFeedFilter*)newItem;
    [self.dataSource addObject:newFeedFilter];
    [self.tableView reloadData];
    [self.delegate filtersListUpdated];
}


@end
