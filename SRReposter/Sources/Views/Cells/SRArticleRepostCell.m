//
//  SRArticleRepostCell.m
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import "SRArticleRepostCell.h"
#import "UIButton+SRButtons.h"

@implementation SRArticleRepostCell

@synthesize fbButton=_fbButton;
@synthesize twButton=_twButton;

-(void)dealloc
{
    self.fbButton=nil;
    self.twButton=nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.textLabel.text=NSLocalizedString(@"[Repost to:]", nil);
        
        self.fbButton=[UIButton facebookButton];
        self.twButton=[UIButton twitterButton];
        
        [self.contentView addSubview:self.fbButton];
        [self.contentView addSubview:self.twButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.fbButton.frame=CGRectMake(CGRectGetMinX(self.twButton.frame)-CELL_LEFT_OFFSET-CGRectGetWidth(self.fbButton.bounds),
                                   (CGRectGetHeight(self.contentView.bounds)-CGRectGetHeight(self.fbButton.bounds))/2,
                                   CGRectGetWidth(self.fbButton.bounds),
                                   CGRectGetHeight(self.fbButton.bounds)
                                   );
    
    self.twButton.frame=CGRectMake(CGRectGetWidth(self.contentView.bounds)-CELL_LEFT_OFFSET-CGRectGetWidth(self.twButton.bounds),
                                   (CGRectGetHeight(self.contentView.bounds)-CGRectGetHeight(self.twButton.bounds))/2,
                                   CGRectGetWidth(self.twButton.bounds),
                                   CGRectGetHeight(self.twButton.bounds)
                                   );
    
    self.textLabel.frame=CGRectMake(CELL_LEFT_OFFSET,
                                    CELL_LEFT_OFFSET,
                                    CGRectGetWidth(self.contentView.bounds)-4*CELL_LEFT_OFFSET-CGRectGetWidth(self.fbButton.bounds)-CGRectGetWidth(self.twButton.bounds),
                                    CGRectGetHeight(self.contentView.bounds)-2*CELL_LEFT_OFFSET
                                    );

}

@end
