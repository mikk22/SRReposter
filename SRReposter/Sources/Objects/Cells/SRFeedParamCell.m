//
//  SRFeedParamCell.m
//  SRReposter
//
//  Created by Mihail Koltsov on 8/21/12.
//

#import "SRFeedParamCell.h"

@implementation SRFeedParamCell

@synthesize textField=_textField;

-(void)dealloc
{
    self.textField=nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.textField=[[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.backgroundColor=[UIColor clearColor];
        self.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        self.textField.font=[UIFont boldSystemFontOfSize:17.f];
        [self.contentView addSubview:self.textField];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.frame=CGRectMake(CELL_LEFT_OFFSET,
                                    CELL_LEFT_OFFSET,
                                    CGRectGetWidth(self.contentView.bounds)-2*CELL_LEFT_OFFSET,
                                    CGRectGetHeight(self.contentView.bounds)-2*CELL_LEFT_OFFSET);
}


@end
