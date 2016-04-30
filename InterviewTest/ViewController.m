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

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *allPhotos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
                [photos addObject:photoData];
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
    
    FlickrKit *fk = [FlickrKit sharedFlickrKit];

    NSDictionary *photo  = self.allPhotos[indexPath.row];
    NSURL *photoURL      = [fk photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photo];

    FlickrCell *cell     = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
