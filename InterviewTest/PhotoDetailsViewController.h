//
//  PhotoDetailsViewController.h
//  InterviewTest
//
//  Created by Ricardo Borelli on 4/30/16.
//  Copyright © 2016 Shore GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoDetailsViewControllerDelegate <NSObject>
@required
- (void)didTapClosePhotoDetails;

@end

@interface PhotoDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) id<PhotoDetailsViewControllerDelegate> delegate;

/**
 *  Set the data that will be displayed
 *
 *  @param imageURL Image URL to display
 *  @param title Title text to display
 *
 */
- (void)setupWithImageURL:(NSURL *)imageURL title:(NSString *)title;

- (IBAction)closeTap;

@end
