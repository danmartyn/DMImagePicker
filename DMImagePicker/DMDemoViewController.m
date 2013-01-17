//
//  DMDemoViewController.m
//  DMImagePicker
//
//  Created by Daniel Martyn on 2013-01-17.
//  Copyright (c) 2013 Dan Martyn. All rights reserved.
//

#import "DMDemoViewController.h"
#import "DMImagePickerViewController.h"

@interface DMDemoViewController () <DMImagePickerControllerDelegate>

@end

@implementation DMDemoViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    NSLog(@"user cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: dismiss image picker
}

- (void)userPickedImages:(NSArray *)pickedImages
{
    NSLog(@"user picked %d images", pickedImages.count);
    [self dismissViewControllerAnimated:YES completion:^{
        // TODO: do something usefull with the pickedImages array
        NSLog(@"pickedImages contains\n%@", pickedImages);
    }];
}

@end







