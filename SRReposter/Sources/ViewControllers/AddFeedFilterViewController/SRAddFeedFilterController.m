//
//  SRAddFeedFilterController.m
//  SRReposter
//
//  Created by user on 23.08.12.
//

#import "SRAddFeedFilterController.h"
#import "SRFeedParamCell.h"
#import "SRArticleRepostCell.h"
#import "SRFBReposter.h"
#import "SRTwitterReposter.h"
#import "RPLSHKFacebook.h"

@interface SRAddFeedFilterController ()
{
    SREditMode      _editMode;
    UITextField     *_feedFilterName;
    UITextField     *_feedFilterNewKeyword;
}

@property (nonatomic)           SREditMode      editMode;
@property (nonatomic,strong)    UITextField     *feedFilterName;
@property (nonatomic,strong)    UITextField     *feedFilterNewKeyword;

-(void)_setupNavigationBar;
-(void)_buttonCancelTouch:(id)sender;
-(void)_buttonOKTouch:(id)sender;
-(void)fbRepostButtonTouch:(id)sender;
-(void)twRepostButtonTouch:(id)sender;


//cells
-(SRFeedParamCell*)filterNameCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
-(UITableViewCell*)filterKeywordCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
-(UITableViewCell*)filterNewKeywordCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
-(UITableViewCell*)filterRepostCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;


@end

@implementation SRAddFeedFilterController

@synthesize feedFilterName=_feedFilterName;
@synthesize feedFilterNewKeyword=_feedFilterNewKeyword;

-(void)dealloc
{
    self.feedFilterNewKeyword=nil;
    self.feedFilterName=nil;
    self.feedFilter=nil;
}


- (id)initWithEditMode:(SREditMode)editMode
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.editMode=editMode;
        if (editMode==SRModeAdd)
        {
            self.feedFilter=[CDFeedFilter MR_createEntity];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupNavigationBar];
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
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"[OK]", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(_buttonOKTouch:)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"[Cancel]", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(_buttonCancelTouch:)];
}



#pragma mark - Button Touches -

-(void)_buttonCancelTouch:(id)sender
{
    if (self.editMode==SRModeAdd)
        [self.feedFilter MR_deleteEntity];

    [self.navigationController dismissModalViewControllerAnimated:YES];
}


-(void)_buttonOKTouch:(id)sender
{
    if (self.feedFilterName.text &&  ![self.feedFilterName.text isEqualToString:@""] && self.feedFilter.keyword)
    {
        switch (self.editMode)
        {
            case SRModeAdd:
            {
                if ([self.delegate respondsToSelector:@selector(addItem:)])
                    [self.delegate addItem:self.feedFilter];
                break;
            }
            case SRModeEdit:
            {
                if ([self.delegate respondsToSelector:@selector(updateItem:)])
                    [self.delegate updateItem:self.feedFilter];
                break;
            }
            default:
                break;
        }
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    } else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"First you must enter Name and at least one  keyword" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}



#pragma mark - Buttons Touches -

-(void)fbRepostButtonTouch:(id)sender
{
    RPLSHKFacebook *shkFb=[[RPLSHKFacebook alloc] init];
    [shkFb authorizeWithFinishBlock:^(NSString *code)
    {
        DLog(@"");
        self.feedFilter.repostFB=[NSNumber numberWithBool:![self.feedFilter.repostFB boolValue]];
        [self.tableView reloadData];
    } errorBlock:^(NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


-(void)twRepostButtonTouch:(id)sender
{
    if([TWTweetComposeViewController canSendTweet])
    {
        self.feedFilter.repostTW=[NSNumber numberWithBool:![self.feedFilter.repostTW boolValue]];
        [self.tableView reloadData];
    } else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"[Create Twitter account in Settings]", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}




#pragma mark - Table view data source

-(SRFeedParamCell*)filterNameCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"filterNameCell";
    SRFeedParamCell *cell = (SRFeedParamCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[SRFeedParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textField.delegate=self;
        self.feedFilterName=cell.textField;
        self.feedFilterName.placeholder=NSLocalizedString(@"[Filter Name]", nil);
    }
    
    cell.textField.text=self.feedFilter.name;
    
    return cell;
}

-(UITableViewCell*)filterKeywordCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"filterKeyWordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=[[self.feedFilter.keyword componentsSeparatedByString:@"::"] objectAtIndex:indexPath.row];

    
    return cell;
}

-(SRFeedParamCell*)filterNewKeywordCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"filterNewKeywordCell";
    SRFeedParamCell *cell = (SRFeedParamCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[SRFeedParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        self.feedFilterNewKeyword=cell.textField;
        self.feedFilterNewKeyword.delegate=self;
    }
    
    cell.textField.placeholder=NSLocalizedString(@"[New keyword]", nil);
    
    return cell;
}

-(SRArticleRepostCell*)filterRepostCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"filterRepostCell";
    SRArticleRepostCell *cell = (SRArticleRepostCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[SRArticleRepostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.fbButton addTarget:self action:@selector(fbRepostButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [cell.twButton addTarget:self action:@selector(twRepostButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
 
    cell.fbButton.selected=[self.feedFilter.repostFB boolValue] ? YES : NO;
    cell.twButton.selected=[self.feedFilter.repostTW boolValue] ? YES : NO;
    
    
    return cell;
}




-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"[Filter Name]", nil);
        case 1:
            return NSLocalizedString(@"[Filter Keywords]", nil);
        default:
            return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return SRFilterSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case SRFilterKeywordsSection:
        {
            NSArray *keywords=[self.feedFilter.keyword componentsSeparatedByString:@"::"];
            DLog(@"COUNT %d",keywords.count);
            return keywords.count+1;
        }
        case SRFilterNameSection:
        case SRFilterRepostSection:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case SRFilterNameSection:
            return [self filterNameCellForTableview:tableView indexPath:indexPath];
        case SRFilterKeywordsSection:
        {
            NSArray *keywords=[self.feedFilter.keyword componentsSeparatedByString:@"::"];
            if (indexPath.row==keywords.count)
            {
                return [self filterNewKeywordCellForTableview:tableView indexPath:indexPath];
            } else
            {
                return [self filterKeywordCellForTableview:tableView indexPath:indexPath];
            }
        }
        case SRFilterRepostSection:
            return [self filterRepostCellForTableview:tableView indexPath:indexPath];
        default:
            return nil;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *keywords=[self.feedFilter.keyword componentsSeparatedByString:@"::"];
    return (indexPath.section==SRFilterKeywordsSection && indexPath.row<keywords.count) ? YES : NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *keywords=[NSMutableArray arrayWithArray:[self.feedFilter.keyword componentsSeparatedByString:@"::"]];
        [keywords removeObjectAtIndex:indexPath.row];
        self.feedFilter.keyword=keywords.count ? [keywords componentsJoinedByString:@"::"] : nil;
        [self.tableView reloadData];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}









#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.feedFilterNewKeyword] && ![textField.text isEqualToString:@""])
    {
        NSArray *keywords=[self.feedFilter.keyword componentsSeparatedByString:@"::"];
        keywords=keywords ? keywords : [NSArray array];
        DLog(@"1_KEYWORDS %@",keywords);
        self.feedFilter.keyword=[[keywords arrayByAddingObject:textField.text] componentsJoinedByString:@"::"];
        self.feedFilterNewKeyword.text=@"";
        
        DLog(@"KEYWORDS %@",self.feedFilter.keyword);
    } else
        if ([textField isEqual:self.feedFilterName])
        {
            self.feedFilter.name=self.feedFilterName.text;
        }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
