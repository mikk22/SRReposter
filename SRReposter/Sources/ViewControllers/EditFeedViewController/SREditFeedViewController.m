//
//  SRaddFeedViewController.m
//  SRReposter
//
//  Created by Mihail Koltsov on 8/21/12.
//

#import "SREditFeedViewController.h"
#import "SRFeedParamCell.h"

@interface SREditFeedViewController ()

@property (nonatomic)           SREditMode      editMode;
@property (nonatomic)           UITextField     *feedNameTextField;
@property (nonatomic)           UITextField     *feedURLTextField;


-(void)_setupNavigationBar;
-(void)_buttonCancelTouch:(id)sender;
-(void)_buttonOKTouch:(id)sender;

@end

@implementation SREditFeedViewController

- (id)initWithEditMode:(SREditMode)editMode
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.editMode=editMode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupNavigationBar];
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
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


-(void)_buttonOKTouch:(id)sender
{
    if (self.feedNameTextField.text &&  ![self.feedNameTextField.text isEqualToString:@""] &&
        self.feedURLTextField.text && ![self.feedURLTextField.text isEqualToString:@""])
    {
        switch (self.editMode)
        {
            case SRModeAdd:
            {
                if ([self.delegate respondsToSelector:@selector(addItem:)])
                {
                    SRFeed *feedItem=[SRFeed itemNamed:self.feedNameTextField.text withUrl:self.feedURLTextField.text];
                    [self.delegate addItem:feedItem];
                }
                break;
            }
            case SRModeEdit:
            {
                if ([self.delegate respondsToSelector:@selector(updateItem:)])
                {
                    self.feedItem.name=self.feedNameTextField.text;
                    self.feedItem.url=self.feedURLTextField.text;
                    [self.delegate updateItem:self.feedItem];
                }
                break;
            }
            default:
                break;
        }

        [self.navigationController dismissModalViewControllerAnimated:YES];
    } else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"First enter Name and Url" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}


#pragma mark - Table view data source

-(SRFeedParamCell*)feedNameCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"nameCell";
    SRFeedParamCell *cell = (SRFeedParamCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[SRFeedParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textField.delegate=self;
        
        cell.textField.placeholder=NSLocalizedString(@"[Enter Feed Name]",nil);
        self.feedNameTextField=cell.textField;
    }
    
   if (self.editMode==SRModeEdit)
       self.feedNameTextField.text=self.feedItem.name;
    
    return cell;
}

-(SRFeedParamCell*)feedURLCellForTableview:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"urlCell";
    SRFeedParamCell *cell = (SRFeedParamCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell=[[SRFeedParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textField.delegate=self;
        
        cell.textField.placeholder=NSLocalizedString(@"[Enter Feed URL]",nil);
        self.feedURLTextField=cell.textField;
    }
    
    if (self.editMode==SRModeEdit)
        self.feedURLTextField.text=self.feedItem.url;
    
    return cell;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"[Feed Name]", nil);
        case 1:
            return NSLocalizedString(@"[Feed URL]", nil);
        default:
            return @"";
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            return [self feedNameCellForTableview:tableView indexPath:indexPath];
        }
        case 1:
        {
            return [self feedURLCellForTableview:tableView indexPath:indexPath];
        }
        default:
            return nil;
    }
}

#pragma mark - UItableView Delegate - 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark
#pragma mark UITextFieldDelegate




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
