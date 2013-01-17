//
//  DMDemoViewController.h
//  DMImagePicker
//
//  Created by Daniel Martyn on 2013-01-17.
//  Copyright (c) 2013 Dan Martyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMDemoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *originalImageView;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

- (IBAction)getPicturesModal:(id)sender;
- (IBAction)getPicturesNavigation:(id)sender;
- (IBAction)getPicturesPopover:(id)sender;

@end
