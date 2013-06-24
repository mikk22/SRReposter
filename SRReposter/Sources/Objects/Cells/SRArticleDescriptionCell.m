//
//  SRArticleDescriptionCell.m
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import "SRArticleDescriptionCell.h"
#import "NSString+HTML.h"

@implementation SRArticleDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.font=DEFAULT_FONT;        
    }
    return self;
}

-(void)layoutSubviews
{
    
    
    [super layoutSubviews];
    self.textLabel.frame=CGRectMake(CELL_LEFT_OFFSET,
                                    CELL_LEFT_OFFSET,
                                    320.f-2*CELL_LEFT_OFFSET, 
                                    [SRArticleDescriptionCell labelHeightWithText:self.textLabel.text withFont:self.textLabel.font]);
    
    self.detailTextLabel.frame=CGRectZero;
}

@end
