//
//  ProfileCell.h
//  instagram
//
//  Created by Laura Jankowski on 6/28/22.
//

#import <UIKit/UIKit.h>
@import Parse;
NS_ASSUME_NONNULL_BEGIN
@interface ProfileCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePostImage;

@end

NS_ASSUME_NONNULL_END
