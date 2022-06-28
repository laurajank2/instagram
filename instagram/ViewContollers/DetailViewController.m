//
//  DetailViewController.m
//  instagram
//
//  Created by Laura Jankowski on 6/28/22.
//

#import "DetailViewController.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *caption;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.caption.text = self.post[@"caption"];
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
