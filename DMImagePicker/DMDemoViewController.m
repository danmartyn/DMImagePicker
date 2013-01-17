//
//  DMDemoViewController.m
//  DMImagePicker
//
//  Created by Daniel Martyn on 2013-01-17.
//  Copyright (c) 2013 Dan Martyn. All rights reserved.
//

#import "DMDemoViewController.h"

@interface DMDemoViewController ()

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
    NSLog(@"get pictures modal");
}

- (IBAction)getPicturesNavigation:(id)sender
{
    NSLog(@"get pictures navigation");
}

- (IBAction)getPicturesPopover:(id)sender
{
    NSLog(@"get pictures popover");
}

@end
