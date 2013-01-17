//
//  DMImagePickerViewController.m
//  DMImagePicker
//
//  Created by Daniel Martyn on 2013-01-17.
//  Copyright (c) 2013 Dan Martyn. All rights reserved.
//

#import "DMImagePickerViewController.h"
#import <ImageIO/ImageIO.h>

@interface DMImagePickerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *selectedImages;
@end

@implementation DMImagePickerViewController

#pragma mark - Custom Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // setup the view
        self.view.backgroundColor = [UIColor redColor];
        
        // setup the nav stuff
        self.navigationItem.title = @"Camera Roll";
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPickingImages)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        // setup a toolbar
        CGRect toolbarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 108, [[UIScreen mainScreen] bounds].size.width, 44);
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        
        // create the toolbar buttons
        // TODO: make sure camera is available
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(useCamera)];
        cameraButton.style = UIBarButtonItemStyleBordered;
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All", @"Selected"]];
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem *segmentedControlbutton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        
        UIBarButtonItem *flexibleSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pickedPictures)];
        doneButton.style = UIBarButtonItemStyleDone;
//        doneBurtton.enabled = NO;
        
        // add the buttons to the toolbar
        [toolbar setItems:@[cameraButton, flexibleSpace, segmentedControlbutton, flexibleSpace2, doneButton]];
        
        // add the toolbar to the view
        [self.view addSubview:toolbar];
        
        // add the collection views in the middle
        
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedImages = @[].mutableCopy;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (void)cancelPickingImages
{
    [self.delegate userCancelledPickingImages];
}

- (void)useCamera
{
    // setup the camera
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.delegate = self;
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    camera.allowsEditing = NO;

    // show the camera
    [self presentViewController:camera animated:YES completion:nil];
}

- (void)segmentedControlChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"all pictures (camera roll)");
            break;
        case 1:
            NSLog(@"selected pictures");
        default:
            break;
    }
}

- (void)pickedPictures
{
    [self.delegate userPickedImages:self.selectedImages.copy];
}

#pragma mark - Helper Methods

- (UIImage *)thumbnailFromImage:(UIImage *)originalImage withLength:(float)length
{
    BOOL widthGreaterThanHeight = (originalImage.size.width > originalImage.size.height);
    float sideFull = (widthGreaterThanHeight) ? originalImage.size.height : originalImage.size.width;
    CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
    
    //creating a square context the size of the final image which we will then
    // manipulate and transform before drawing in the original image
    UIGraphicsBeginImageContext(CGSizeMake(length, length));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextClipToRect(currentContext, clippedRect);
    CGFloat scaleFactor = length/sideFull;
    if (widthGreaterThanHeight) {
        //a landscape image – make context shift the original image to the left when drawn into the context
        CGContextTranslateCTM(currentContext, -(((originalImage.size.width - sideFull) / 2) * scaleFactor), 0);
    }
    else {
        //a portfolio image – make context shift the original image upwards when drawn into the context
        CGContextTranslateCTM(currentContext, 0, -(((originalImage.size.height - sideFull) / 2) * scaleFactor));
    }
    //this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
    CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);

    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSData *imageData = UIImagePNGRepresentation(thumbnail);
//    [imageData writeToFile:fullPathToThumbImage atomically:YES];
//    thumbnail = [UIImage imageWithContentsOfFile:fullPathToThumbImage];

    return thumbnail;
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // dismiss the camera view
    [self dismissViewControllerAnimated:YES completion:^{
        // create the original and thumbnail images
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        UIImage *thumbnail = [self thumbnailFromImage:originalImage withLength:100.0];
        
        // create a dictionary objec to hold these images
        NSDictionary *imageDictionary = @{@"original":originalImage, @"thumbnail":thumbnail};
        
        // add them to the selected array
        [self.selectedImages addObject:imageDictionary];
    }];
}

@end
