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

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *profileFeed;
@property (nonatomic, strong) NSArray *profilePosts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.profileImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.profileImage.layer setBorderWidth: 1.5];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    self.usernameLabel.text = user.username;
    self.profileFeed.dataSource = self;
    self.profileFeed.delegate = self;
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

- (IBAction)setImage:(id)sender {
    [self getImagePicker];
}


- (void)getImagePicker {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1000, 1000, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profileImage.image = originalImage;
    PFUser *user = [PFUser currentUser];
    //user.profileImage = self.profileImage.image;
    
    

    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
