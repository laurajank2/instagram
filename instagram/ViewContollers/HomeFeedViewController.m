//
//  HomeFeedViewController.m
//  instagram
//
//  Created by Laura Jankowski on 6/27/22.
//

#import "HomeFeedViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "ComposeViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "DateTools.h"


@interface HomeFeedViewController ()<ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // construct query
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    [self fetchPosts];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.postsTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchPosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = posts;
            NSLog(@"the posts:");
            NSLog(@"%@", self.posts);
            [self.postsTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginViewController *loginViewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        sceneDelegate.window.rootViewController = loginViewcontroller;
    }];
    
}

- (void)didPost {
    [self fetchPosts];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    //buttons
    NSString *likeString = [post[@"likeCount"] stringValue];
    [cell.likeBtn setTitle:likeString forState:UIControlStateNormal];
    NSString *commentString = [post[@"commentCount"] stringValue];
    [cell.messageBtn setTitle:commentString forState:UIControlStateNormal];
    //labels
    cell.postCaption.text = post[@"caption"];
    cell.usernameField.text = post.author.username;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@%@%@", @"Created ",  post.createdAt.shortTimeAgoSinceNow, @" ago"];
    //image
    cell.postImage.file = post[@"image"];
    [cell.postImage loadInBackground];
    cell.userImage.file = post.author[@"profileImage"];
    [cell.userImage loadInBackground];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        PostCell *cell = sender;
        NSIndexPath *indexPath = [self.postsTableView indexPathForCell:cell];
        //do cell for row at index path to get the dictionary
        PFObject *postToPass = self.posts[indexPath.row];
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.post = postToPass;
    } else if ([[segue identifier] isEqualToString:@"PostSegue"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ComposeViewController *composeVC = navVC.topViewController;
        composeVC.delegate = self;
        NSLog(@"@%@", composeVC.delegate);
    }
    
}


@end
