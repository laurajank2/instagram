//
//  SettingsViewController.h
//  instagram
//
//  Created by Laura Jankowski on 6/29/22.
//

#import <UIKit/UIKit.h>
@import Parse;
NS_ASSUME_NONNULL_BEGIN
@protocol SettingsViewControllerDelegate

- (void)didChange;

@end
@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
