//
//  DMDemoViewController.m
//  DMImagePicker
//
//  Created by Daniel Martyn on 2013-01-17.
//  Copyright (c) 2013 Dan Martyn. All rights reserved.
//

#import "DMDemoViewController.h"
#import "DMImagePickerViewController.h"
#import "UIImageExtras.h"

@interface DMDemoViewController () <DMImagePickerControllerDelegate>
@property (nonatomic, strong) NSArray *images;
@end

@implementation DMDemoViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.images = @[];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)getPicturesModal:(id)sender
{
    DMImagePickerViewController *picker = [[DMImagePickerViewController alloc] init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.selectedImages = self.images.mutableCopy;
    picker.maxSelectableImages = 5;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)getPicturesNavigation:(id)sender
{
    NSLog(@"get pictures navigation");
}

- (IBAction)getPicturesPopover:(id)sender
{
    NSLog(@"get pictures popover");
}

#pragma mark - DMImagePickerControllerDelegate Methods

- (void)userCancelledPickingImages
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userPickedImages:(NSArray *)pickedImages
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.images = pickedImages;
        
        NSDictionary *image = pickedImages[0];
        
        CGSize originalImageViewFrameSize = self.originalImageView.frame.size;
        CGSize thumbnailImageViewFrameSize = self.thumbnailImageView.frame.size;
        
        self.originalImageView.image = [image[@"original"] imageByScalingAndCroppingForSize:originalImageViewFrameSize];
        self.thumbnailImageView.image = [image[@"thumbnail"] imageByScalingAndCroppingForSize:thumbnailImageViewFrameSize];
    }];
}

@end







