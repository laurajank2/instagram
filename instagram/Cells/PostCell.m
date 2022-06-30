//
//  PostCell.m
//  instagram
//
//  Created by Laura Jankowski on 6/27/22.
//

#import "PostCell.h"
#import "DateTools.h"


@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)newPost {
    _post = newPost;
    //self.postImage.file = post[@"image"];
    //[self.postImage loadInBackground];
    NSLog(@"%@", self.post.likeCount);
    NSString *likeString = [self.post[@"likeCount"] stringValue];
    [self.likeBtn setTitle:likeString forState:UIControlStateNormal];
    NSString *commentString = [self.post[@"commentCount"] stringValue];
    [self.messageBtn setTitle:commentString forState:UIControlStateNormal];
    //labels
    self.postCaption.text = self.post[@"caption"];
    self.usernameField.text = self.post.author.username;
    self.dateLabel.text = [NSString stringWithFormat:@"%@%@%@", @"Created ",  self.post.createdAt.shortTimeAgoSinceNow, @" ago"];
    //image
    self.postImage.file = self.post[@"image"];
    [self.postImage loadInBackground];
    self.userImage.file = self.post.author[@"profileImage"];
    [self.userImage loadInBackground];
}

//attempt to get likes to work
- (IBAction)didLike:(id)sender {
    if ([self.post[@"likeCount"] isEqual:nil]) {
        NSInteger intLikeCount = [self.post[@"likeCount"] integerValue];
        NSNumber *numberLikeCount = [NSNumber numberWithInteger: intLikeCount + 1];
        NSLog(@"%@", numberLikeCount);
        self.post.likeCount = numberLikeCount;
        NSLog(@"%@", self.post.likeCount);
    } else {
        self.post[@"likeCount"] = @1;
        NSLog(@"%@", self.post.likeCount);
    }
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"saving");
        if(error){
              NSLog(@"Error posting: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully posted");

         }
    }];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query getObjectInBackgroundWithId:self.post.objectId
//                                 block:^(PFObject *post, NSError *error) {
//        // Now let's update it with some new data. In this case, only cheatMode and score
//        // will get sent to the cloud. playerName hasn't changed.
//        post[@"likeCount"] = @1;
//        [post saveInBackground];
//    }];
    
}

- (IBAction)didComment:(id)sender {
}

@end
