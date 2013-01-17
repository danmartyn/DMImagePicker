//
//  DMImagePickerViewController.h
//  DMImagePicker
//
//  Created by Daniel Martyn on 2013-01-17.
//  Copyright (c) 2013 Dan Martyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMImagePickerControllerDelegate
- (void)userCancelledPickingImages;
- (void)userPickedImages:(NSArray *)pickedImages;
@end


@interface DMImagePickerViewController : UIViewController

@property (nonatomic, weak) id<DMImagePickerControllerDelegate> delegate;

@end
