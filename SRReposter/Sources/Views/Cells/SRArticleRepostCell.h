//
//  SRArticleRepostCell.h
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import <UIKit/UIKit.h>
#import "SRArticleCell.h"

@interface SRArticleRepostCell : UITableViewCell
{
    UIButton    *_fbButton;
    UIButton    *_twButton;
}

@property (nonatomic, strong)   UIButton    *fbButton;
@property (nonatomic, strong)   UIButton    *twButton;

@end
