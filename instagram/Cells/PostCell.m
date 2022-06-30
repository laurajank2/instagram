//
//  PostCell.m
//  instagram
//
//  Created by Laura Jankowski on 6/27/22.
//

#import "PostCell.h"


@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    self.post = post;
    self.postImage.file = post[@"image"];
    [self.postImage loadInBackground];
}
- (IBAction)didLike:(id)sender {
    NSInteger intLikeCount = [self.post.likeCount integerValue];
    NSNumber *numberLikeCount = [NSNumber numberWithInteger: intLikeCount + 1];
    self.post.likeCount = numberLikeCount;
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
              NSLog(@"Error posting: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully posted");

         }
    }];
}

- (IBAction)didComment:(id)sender {
}

@end
