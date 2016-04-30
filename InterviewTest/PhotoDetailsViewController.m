//
//  PhotoDetailsViewController.m
//  InterviewTest
//
//  Created by Ricardo Borelli on 4/30/16.
//  Copyright © 2016 Shore GmbH. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoDetailsViewController ()

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSURL *imageURL;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.closeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.closeButton.layer.borderWidth = 1.0;
    self.closeButton.layer.cornerRadius = self.closeButton.frame.size.width/2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.titleLabel.text = self.titleText;
    [self.photoImageView setImageWithURL:self.imageURL];
}

- (void)setupWithImageURL:(NSURL *)imageURL title:(NSString *)title {
    self.titleText = title;
    self.imageURL = imageURL;
}

- (IBAction)closeTap {
    [self.delegate didTapClosePhotoDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
