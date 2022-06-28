//
//  ComposeViewController.m
//  instagram
//
//  Created by Laura Jankowski on 6/27/22.
//

#import "ComposeViewController.h"
#import "Post.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *toPostImage;
@property (weak, nonatomic) IBOutlet UITextView *toPostCaption;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self.toPostImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.toPostImage.layer setBorderWidth: 1.5];
}
- (IBAction)changeImage:(id)sender {
    [self getImagePicker];
}

- (IBAction)didTapImage:(id)sender {
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
    self.toPostImage.image = originalImage;
    
    

    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)postThis:(id)sender {
    CGFloat width = self.toPostImage.bounds.size.width * 10;
    CGFloat height = self.toPostImage.bounds.size.height * 10;
    CGSize newSize = CGSizeMake(width, height);
    [Post postUserImage:[self resizeImage:self.toPostImage.image withSize:newSize] withCaption:self.toPostCaption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Successfully posted image!");
            [self.delegate didPost];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            NSLog(@"Error posting image: %@", error);
        }
    }];
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
