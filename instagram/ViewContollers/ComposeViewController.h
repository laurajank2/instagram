//
//  ComposeViewController.h
//  instagram
//
//  Created by Laura Jankowski on 6/27/22.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didPost;

@end

@interface ComposeViewController : ViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
