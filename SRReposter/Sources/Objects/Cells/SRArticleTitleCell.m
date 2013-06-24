//
//  SRArticleTitleCell.m
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import "SRArticleTitleCell.h"

@implementation SRArticleTitleCell

+(CGFloat)cellHeightWithText:(NSString *)text
{
    return ([SRArticleCell cellHeightWithText:text]+20.f);
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.textAlignment=UITextAlignmentCenter;
        self.textLabel.font=TITLE_FONT;
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame=CGRectMake(CELL_LEFT_OFFSET,
                                          CELL_LEFT_OFFSET,
                                          320.f-2*CELL_LEFT_OFFSET, 
                                    [SRArticleTitleCell labelHeightWithText:self.textLabel.text withFont:self.textLabel.font]);
    
    self.detailTextLabel.frame=CGRectMake(CELL_LEFT_OFFSET,
                                          CGRectGetMaxY(self.textLabel.frame),
                                          320.f-2*CELL_LEFT_OFFSET, 
                                          20.f);
}

@end
