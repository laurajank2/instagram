//
//  DetailViewController.m
//  instagram
//
//  Created by Laura Jankowski on 6/28/22.
//

#import "DetailViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "DateTools.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username.text = self.post.author.username;
    self.caption.text = self.post[@"caption"];
    self.timeStamp.text = [NSString stringWithFormat:@"%@%@%@", @"Created ",  self.post.createdAt.shortTimeAgoSinceNow, @" hours ago"];
    self.detailImage.file = self.post[@"image"];
    [self.detailImage loadInBackground];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
