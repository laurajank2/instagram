//
//  PostCell.h
//  instagram
//
//  Created by Laura Jankowski on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;
NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *usernameField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

NS_ASSUME_NONNULL_END
