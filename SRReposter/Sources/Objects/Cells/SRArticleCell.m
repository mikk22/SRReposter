//
//  SRArticleCell.m
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import "SRArticleCell.h"

@implementation SRArticleCell


+(CGFloat)cellHeightWithText:(NSString *)text
{
    CGFloat height=[SRArticleCell labelHeightWithText:text withFont:DEFAULT_FONT];
    return (2*CELL_LEFT_OFFSET+height);
}

+(CGFloat)labelHeightWithText:(NSString *)text withFont:(UIFont*)font
{
    CGSize maximumSize=CGSizeMake(320.f-2*CELL_LEFT_OFFSET, MAXFLOAT);
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.textLabel.numberOfLines=0;
        self.detailTextLabel.numberOfLines=0;
    }
    return self;
}


@end
