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
    
}
- (IBAction)didComment:(id)sender {
}

@end
