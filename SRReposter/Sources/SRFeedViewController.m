//
//  SRFeedViewController.m
//  SRReposter
//
//  Created by user on 18.08.12.
//  Copyright (c) 2012 Intelvision. All rights reserved.
//

#import "SRFeedViewController.h"
#import "SRFeedItem.h"

@interface SRFeedViewController ()
{
    NSArray *_feedItems;
}
-(void)_setupNavigationBar;
//buttons touches
-(void)_buttonSetupFeedTouch:(id)sender;
-(void)_buttonSetupFeedFiltersTouch:(id)sender;

@property (nonatomic, strong)   NSArray *feedItems;

@end

@implementation SRFeedViewController

@synthesize feedItems=_feedItems;

-(void)dealloc
{

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupNavigationBar];
    
    SRFeedItem *item1=[SRFeedItem itemWithBlogTitle:@"Blogtitle" articleTitle:@"ArticleTitle" articleUrl:@"URL" articleDate:[NSDate date]];
    SRFeedItem *item2=[SRFeedItem itemWithBlogTitle:@"Blogtitle2" articleTitle:@"ArticleTitle2" articleUrl:@"URL2" articleDate:[NSDate date]];
    SRFeedItem *item3=[SRFeedItem itemWithBlogTitle:@"Blogtitle3" articleTitle:@"ArticleTitle3" articleUrl:@"URL3" articleDate:[NSDate date]];
    
    self.feedItems=[NSArray arrayWithObjects:item1,
                                             item2,
                                             item3,
                                             nil];
    
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
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"[Filters]", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(_buttonSetupFeedFiltersTouch:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"[Feed]", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(_buttonSetupFeedTouch:)];
}



#pragma mark - Button Touches -

-(void)_buttonSetupFeedTouch:(id)sender
{
    DLog(@"FEED TOUCH");
}


-(void)_buttonSetupFeedFiltersTouch:(id)sender
{
    DLog(@"FEED_FILTERS TOUCH");
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FeedItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SRFeedItem *entry = [self.feedItems objectAtIndex:indexPath.row];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *articleDateString = [dateFormatter stringFromDate:entry.articleDate];
    
    cell.textLabel.text = entry.articleTitle;        
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, entry.blogTitle];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
