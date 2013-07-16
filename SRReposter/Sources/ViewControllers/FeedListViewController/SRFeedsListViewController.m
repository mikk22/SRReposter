//
//  SRFeedSelectorViewController.m
//  SRReposter
//
//  Created by user on 20.08.12.
//

#import "SRFeedsListViewController.h"
#import "SRPostsListViewController.h"
#import "SREditFeedViewController.h"
#import "SRFeed.h"

@interface SRFeedsListViewController ()

@property (nonatomic, strong) SRFeedModel       *dataSource;
@property (nonatomic)         BOOL              editMode;

-(void)_setupNavigationBar;
-(void)_editModeButtonTouch:(id)sender;
-(void)_addNewFeedButtonTouch:(id)sender;
@end

@implementation SRFeedsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupNavigationBar];
    
    [self.dataSource load];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.dataSource=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)_setupNavigationBar
{
    self.navigationItem.title=NSLocalizedString(@"[News feed]", nil);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_addNewFeedButtonTouch:)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"[Edit]", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(_editModeButtonTouch:)];
}


#pragma mark - Properties - 


-(SRFeedModel*)dataSource
{
    if (!_dataSource)
    {
        _dataSource= SRFeedModel.new;
        _dataSource.delegate=self;
    }
    
    return _dataSource;
}

#pragma mark - Button Touches -

-(void)_addNewFeedButtonTouch:(id)sender
{
    SREditFeedViewController *addFeedViewController=[[SREditFeedViewController alloc] initWithEditMode:SRModeAdd];
    addFeedViewController.delegate=self;
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:addFeedViewController];
    [self.navigationController presentModalViewController:navigationController animated:YES];
}


-(void)_editModeButtonTouch:(id)sender
{
    self.editMode=!self.editMode;
    self.navigationItem.leftBarButtonItem=self.editMode ? [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"[Done]",nil) style:UIBarButtonItemStyleDone target:self action:@selector(_editModeButtonTouch:)] :
                                    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"[Edit]",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(_editModeButtonTouch:)];
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SRFeed *feedItem=[self.dataSource.dataObjects objectAtIndex:indexPath.row];
    cell.textLabel.text=feedItem.name;
    cell.detailTextLabel.text=feedItem.url;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.editMode)
    {
        //edit controller
        CDFeed *feedItem=[self.dataSource.dataObjects objectAtIndex:indexPath.row];
        SREditFeedViewController *addFeedViewController=[[SREditFeedViewController alloc] initWithEditMode:SRModeEdit];
        addFeedViewController.delegate=self;
        addFeedViewController.feedItem=feedItem;
        UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:addFeedViewController];
        [self.navigationController presentModalViewController:navigationController animated:YES];
    } else
    {
        //show feedlist
        SRPostsListViewController *feedListController=[[SRPostsListViewController alloc] initWithFeed:[self.dataSource.dataObjects objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:feedListController animated:YES];
    }
}

#pragma mark - SREdit Delegate -

-(void)updateItem:(id)anObject
{
    [self.dataSource updateObject:anObject];
    [self.tableView reloadData];
}

-(void)addItem:(id)newItem
{
    SRFeed* newFeedItem=(SRFeed*)newItem;
    [self.dataSource addObject:newFeedItem];
    [self.tableView reloadData];
}





#pragma mark - JTModel Delegate -

-(void)modelChanged:(JTModel*)model
{
    if ([model isEqual:self.dataSource])
    {
        [self.tableView reloadData];
    }
}

@end
