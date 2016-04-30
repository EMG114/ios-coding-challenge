//
//  ViewController.m
//  InterviewTest
//
//  Created by Alessandro Pricci on 11/02/16.
//  Copyright © 2016 Shore GmbH. All rights reserved.
//

#import "ViewController.h"
#import "FlickrKit.h"
#import "FlickrCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "Photo.h"
#import "PhotoDetailsViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PhotoDetailsViewControllerDelegate>

@property (strong, nonatomic) NSArray<Photo *> *allPhotos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) PhotoDetailsViewController *photoDetails;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self loadImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup {
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"e1a0bda2a79fce8effb1dd1123f733a0" sharedSecret:@"72ffc260024dafc8"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FlickrCell" bundle:nil]
          forCellWithReuseIdentifier:@"FlickrCell"];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.photoDetails = [[PhotoDetailsViewController alloc] initWithNibName:@"PhotoDetailsViewController" bundle:nil];
    self.photoDetails.delegate = self;
}

-(void)loadImages {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak ViewController *weakSelf = self;
    
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        
        // Note this is not the main thread!
        if (response) {
            NSMutableArray *photos = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                Photo *photo = [[Photo alloc] initWithDictionary:photoData];
                [photos addObject:photo];
            }
            weakSelf.allPhotos = photos;
            
            // the reload must be on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf.collectionView reloadData];
            });
        }
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Photo *photo  = self.allPhotos[indexPath.row];
    NSURL *photoURL      = [photo imageURL];

    FlickrCell *cell     = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.photoDetails.view.superview == nil) {
        Photo *photo = self.allPhotos[indexPath.row];
        NSURL *photoURL = [photo imageURL];
        
        [self.photoDetails setupWithImageURL:photoURL title:photo.title];
        
        self.photoDetails.view.frame = CGRectMake(0, (self.photoDetails.view.frame.size.height * -1),
                                                  self.photoDetails.view.frame.size.width,
                                                  self.photoDetails.view.frame.size.height);
        
        self.photoDetails.view.center = CGPointMake(self.view.center.x, self.photoDetails.view.center.y);
        
        [self.view addSubview:self.photoDetails.view];
        
        self.gravity = [[UIGravityBehavior alloc] initWithItems:@[self.photoDetails.view]];
        
        __weak ViewController *weakSelf = self;
        self.gravity.action = ^{
            if (self.photoDetails.view.frame.origin.y > self.view.frame.size.height) {
                [weakSelf.animator removeBehavior:weakSelf.gravity];
                weakSelf.gravity = nil;
                [weakSelf.photoDetails.view removeFromSuperview];
            }
        };
        
        [self.animator addBehavior:self.gravity];
        
        self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.photoDetails.view]];
        UIBezierPath *box = [UIBezierPath bezierPathWithRect:CGRectMake(self.photoDetails.view.frame.origin.x,
                                                                        self.view.center.y + (self.photoDetails.view.frame.size.height/2),
                                                                        self.photoDetails.view.frame.size.width,
                                                                        self.photoDetails.view.frame.size.height)];
        [self.collision addBoundaryWithIdentifier:@"boundBox" forPath:box];
        
        [self.animator addBehavior:self.collision];
    }
}

- (void)didTapClosePhotoDetails {
    [self.animator removeBehavior:self.collision];
}


@end
