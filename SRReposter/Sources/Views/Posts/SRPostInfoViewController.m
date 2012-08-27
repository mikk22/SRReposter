//
//  SRFeedsSelectViewController.m
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import "SRPostInfoViewController.h"
#import "SRArticleTitleCell.h"
#import "SRArticleDescriptionCell.h"
#import "SRPostWebViewController.h"
#import "SRArticleRepostCell.h"
#import "SRTwitterReposter.h"
#import "SVProgressHUD.h"
#import "SRFBConnect.h"

#import "NSString+HTML.h"

enum
{
    kPostArticleTitle,
    kPostArticleDescription,
    kPostArticleLink,
    kPostRepost,
    kPostCellsCount
};

@interface SRPostInfoViewController ()
{
    CDFeedItem  *_feedItem;
}

+(NSDictionary*)dictionaryFromFeedItem:(CDFeedItem*)cdFeedItem;

//cells
-(SRArticleTitleCell*)articleTitleCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
-(SRArticleDescriptionCell*)articleDescriptionCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
-(UITableViewCell*)articleLinkCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
-(SRArticleRepostCell*)articleRepostCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;


//buttons touches
-(void)fbRepostButtonTouch:(id)sender;
-(void)twRepostButtonTouch:(id)sender;

@end

@implementation SRPostInfoViewController

@synthesize feedItem=_feedItem;

-(void)dealloc
{
    self.feedItem=nil;
}


+(NSDictionary*)dictionaryFromFeedItem:(CDFeedItem*)cdFeedItem
{
    NSString *summary=[[cdFeedItem.summary stringByConvertingHTMLToPlainText] stringByRemovingNewLinesAndWhitespace];
    NSString *content=[[cdFeedItem.content stringByConvertingHTMLToPlainText] stringByRemovingNewLinesAndWhitespace];
    NSDictionary *feedItem=[NSDictionary dictionaryWithObjectsAndKeys:
                            cdFeedItem.title,       @"title",
                            cdFeedItem.link,        @"link",
                            cdFeedItem.date,        @"date",
                            summary,                @"summary",
                            content,                @"content"
                            , nil];
    
    return feedItem;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Properties -

-(void)setFeedItem:(CDFeedItem *)feedItem
{
    _feedItem=feedItem;
    self.navigationItem.title=feedItem.title;
}

#pragma mark - Buttons Touches - 

-(void)fbRepostButtonTouch:(id)sender
{
    [SRFBConnect checkAuthWithFinishBlock:^(BOOL authResult)
    {
        if (authResult)
        {
            NSDictionary *feedItem=[SRPostInfoViewController dictionaryFromFeedItem:self.feedItem];
            [SRFBConnect repostFeedItem:feedItem withFinishBlock:^(BOOL result)
            {
                if (result)
                {
                    self.feedItem.postedFB=[NSNumber numberWithBool:YES];
                    [[NSManagedObjectContext MR_defaultContext] MR_save];
                    [self.tableView reloadData];
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"[Feed Item posted]", nil) duration:SHOW_MESSAGE_DEFAULT_TIME];
                }
                else
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"[Oops! An error has occured!]", nil) duration:SHOW_MESSAGE_DEFAULT_TIME];
            }];
        } else 
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"[Oops! An error has occured!]", nil) duration:SHOW_MESSAGE_DEFAULT_TIME];
        }
    }];
}


-(void)twRepostButtonTouch:(id)sender
{
    if([TWTweetComposeViewController canSendTweet])
    {
        NSDictionary *feedItem=[SRPostInfoViewController dictionaryFromFeedItem:self.feedItem];
        [SRTwitterReposter repostFeedItem:feedItem withFinishBlock:^(BOOL result)
         {
             if (result)
             {
                 self.feedItem.postedTW=[NSNumber numberWithBool:YES];
                 [[NSManagedObjectContext MR_defaultContext] MR_save];
                 [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"[Tweet posted]", nil) duration:SHOW_MESSAGE_DEFAULT_TIME];
                 [self.tableView reloadData];
             }
             else
                 [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"[Oops! An error has occured!]", nil) duration:SHOW_MESSAGE_DEFAULT_TIME];
             
         }];
    } else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"[Create Twitter account in Settings]", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
        
}

#pragma mark - Table view data source

-(SRArticleTitleCell*)articleTitleCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"TitleCell";
    SRArticleTitleCell *cell = (SRArticleTitleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[SRArticleTitleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text=self.feedItem.title;
    
    return cell;
}


-(SRArticleDescriptionCell*)articleDescriptionCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"DescriptionCell";
    SRArticleDescriptionCell *cell = (SRArticleDescriptionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[SRArticleDescriptionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text=[[self.feedItem.summary  stringByConvertingHTMLToPlainText] stringByRemovingNewLinesAndWhitespace];
    
    return cell;
}

-(UITableViewCell*)articleLinkCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"LinkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.textColor=[UIColor blueColor];
    cell.textLabel.text=NSLocalizedString(@"[Read article]", nil);
    return cell;
}

-(SRArticleRepostCell*)articleRepostCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"RepostCell";
    SRArticleRepostCell *cell = (SRArticleRepostCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[SRArticleRepostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.fbButton addTarget:self action:@selector(fbRepostButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [cell.twButton addTarget:self action:@selector(twRepostButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    cell.fbButton.selected=[self.feedItem.postedFB boolValue] ? YES : NO;
    cell.twButton.selected=[self.feedItem.postedTW boolValue] ? YES : NO;

    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case kPostArticleTitle:
            return [SRArticleTitleCell cellHeightWithText:[[self.feedItem.title  stringByConvertingHTMLToPlainText] stringByRemovingNewLinesAndWhitespace]];
        case kPostArticleDescription:
            return [SRArticleDescriptionCell cellHeightWithText:[[self.feedItem.summary  stringByConvertingHTMLToPlainText] stringByRemovingNewLinesAndWhitespace]];
        case kPostArticleLink:
        case kPostRepost:
            return 40.f;
            
        default:
            return 0.f;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kPostCellsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case kPostArticleTitle:
            return [self articleTitleCellForTableview:tableView indexPath:indexPath];
        case kPostArticleDescription:
            return [self articleDescriptionCellForTableview:tableView indexPath:indexPath];
        case kPostArticleLink:
            return [self articleLinkCellForTableview:tableView indexPath:indexPath];
        case kPostRepost:
            return [self articleRepostCellForTableview:tableView indexPath:indexPath];
        default:
        {
            NSAssert(NO,@"CELL can't be nil");
            return nil;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row==kPostArticleLink)
    {
        SRPostWebViewController *postWebcontroller=[[SRPostWebViewController alloc] init];
        postWebcontroller.feedItem=self.feedItem;
        [self.navigationController pushViewController:postWebcontroller animated:YES];
    }
}

@end
