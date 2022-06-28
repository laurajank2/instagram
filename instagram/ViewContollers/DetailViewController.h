//
//  DetailViewController.h
//  instagram
//
//  Created by Laura Jankowski on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;
NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (nonatomic, strong) Post *post;
@end

NS_ASSUME_NONNULL_END
