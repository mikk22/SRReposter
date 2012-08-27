//
//  UIButton+SRButtons.m
//  SRReposter
//
//  Created by user on 26.08.12.
//  Copyright (c) 2012 Intelvision. All rights reserved.
//

#import "UIButton+SRButtons.h"

@implementation UIButton (SRButtons)


+(id)facebookButton
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds=CGRectMake(0, 0, 36.f, 36.f);
    
    if (button)
    {
        [button setImage:[UIImage imageNamed:@"fb_unselected.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"fb_unselected.png"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"fb_selected.png"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"fb_selected.png"] forState:UIControlStateHighlighted];
    }
    return button;
}







+(id)twitterButton
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds=CGRectMake(0, 0, 36.f, 36.f);
    
    if (button)
    {
        [button setImage:[UIImage imageNamed:@"twt_unselected.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"twt_unselected.png"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"twt_selected.png"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"twt_selected.png"] forState:UIControlStateHighlighted];
    }
    return button;
}


@end
