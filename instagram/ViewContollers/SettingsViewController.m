//
//  SettingsViewController.m
//  instagram
//
//  Created by Laura Jankowski on 6/29/22.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface SettingsViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *usernameField;
@property (weak, nonatomic) IBOutlet UITextView *bioField;
@property (weak, nonatomic) IBOutlet UIButton *changePicBtn;
@property (strong, nonatomic) PFUser *user;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.profileImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.profileImage.layer setBorderWidth: 1.5];
    self.user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    self.usernameField.text = user.username;
    self.bioField.text = user[@"bio"];
    self.profileImage.file = user[@"profileImage"];
    [self.profileImage loadInBackground];
    self.usernameField.delegate = self;
    self.bioField.delegate = self;
}

- (IBAction)setImage:(id)sender {
    [self getImagePicker];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    // TODO: Check the proposed new text character count
    // Set the max character limit
    // Construct what the new text would be if we allowed the user's latest edit
    self.user[@"username"] = self.usernameField.text;
    self.user[@"bio"] = self.bioField.text;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
              NSLog(@"Error posting: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully posted");
             [self.delegate didChange];

         }
    }];
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
    CGFloat width = self.profileImage.bounds.size.width * 10;
    CGFloat height = self.profileImage.bounds.size.height * 10;
    CGSize newSize = CGSizeMake(width, height);
    PFFileObject *imgFile = [self getPFFileFromImage:[self resizeImage:self.profileImage.image withSize:newSize]];
    self.user[@"profileImage"] = imgFile;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
              NSLog(@"Error posting: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully posted");
             [self.delegate didChange];
         }
    }];
    
    
    

    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
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
