//
//  SRArticleCell.h
//  SRReposter
//
//  Created by user on 19.08.12.
//

#import <UIKit/UIKit.h>

@interface SRArticleCell : UITableViewCell

+(CGFloat)cellHeightWithText:(NSString *)text;
+(CGFloat)labelHeightWithText:(NSString *)text withFont:(UIFont*)font;

@end
