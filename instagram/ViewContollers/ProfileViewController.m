//
//  ProfileViewController.m
//  instagram
//
//  Created by Laura Jankowski on 6/28/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "ProfileCell.h"
#import "SettingsViewController.h"

@interface ProfileViewController () <SettingsViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *profileFeed;
@property (nonatomic, strong) NSArray *profilePosts;
@property (weak, nonatomic) IBOutlet UILabel *bioField;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.profileImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.profileImage.layer setBorderWidth: 1.5];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    self.usernameLabel.text = user.username;
    self.bioField.text = user[@"bio"];
    self.profileFeed.dataSource = self;
    self.profileFeed.delegate = self;
    NSLog(@"profileImage");
    NSLog(@"%@", user[@"profileImage"]);
    self.profileImage.file = user[@"profileImage"];
    [self.profileImage loadInBackground];
    [self fetchPosts];
    
}

- (void)didChange {
    PFUser *user = [PFUser currentUser];
    self.usernameLabel.text = user.username;
    self.bioField.text = user[@"bio"];
    self.profileFeed.dataSource = self;
    self.profileFeed.delegate = self;
    NSLog(@"profileImage");
    NSLog(@"%@", user[@"profileImage"]);
    self.profileImage.file = user[@"profileImage"];
    [self.profileImage loadInBackground];
    [self fetchPosts];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.profilePosts.count;
}

- (void)fetchPosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.profilePosts = posts;
            NSLog(@"the posts:");
            NSLog(@"%@", self.profilePosts);
            [self.profileFeed reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfileCell *cell = [self.profileFeed dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    Post *post = self.profilePosts[indexPath.row];
    //image
    cell.profilePostImage.file = post[@"image"];
    [cell.profilePostImage loadInBackground];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"editSegue"]) {
       SettingsViewController *settingsVC = [segue destinationViewController];
        settingsVC.delegate = self;
    }
}


@end
