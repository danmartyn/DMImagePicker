//
//  DMImagePickerViewController.m
//  DMImagePicker
//
//  Created by Daniel Martyn on 2013-01-17.
//  Copyright (c) 2013 Dan Martyn. All rights reserved.
//

#import "DMImagePickerViewController.h"
#import "UIImageExtras.h"

#define kCellWidth  75.0
#define kCellHeight 75.0

@interface DMImagePickerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isShowingCameraRoll;
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
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pickedPictures)];
        self.doneButton.style = UIBarButtonItemStyleDone;
        self.doneButton.enabled = NO;
        
        // add the buttons to the toolbar
        [toolbar setItems:@[cameraButton, flexibleSpace, segmentedControlbutton, flexibleSpace2, self.doneButton]];
        
        // add the toolbar to the view
        [self.view addSubview:toolbar];
        
        // add the collection views in the middle
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(kCellWidth, kCellHeight);
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = 2.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
        
        CGRect collectionViewFrame = [[UIScreen mainScreen] bounds];
        collectionViewFrame.size.height -= 108;
        self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor greenColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Image Cell"];
        
        // add the collection view to the subview
        [self.view addSubview:self.collectionView];
        
        self.isShowingCameraRoll = YES;
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"max selectable photos = %d", self.maxSelectableImages);
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
            self.isShowingCameraRoll = YES;
            break;
        case 1:
            self.isShowingCameraRoll = NO;
        default:
            break;
    }
    [self.collectionView reloadData];
}

- (void)pickedPictures
{
    [self.delegate userPickedImages:self.selectedImages.copy];
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
        UIImage *thumbnail = [originalImage imageByScalingAndCroppingForSize:CGSizeMake(100.0, 100.0)];
        
        // create a dictionary objec to hold these images
        NSDictionary *imageDictionary = @{@"original":originalImage, @"thumbnail":thumbnail};
        
        // add them to the selected array
        [self.selectedImages addObject:imageDictionary];
        self.doneButton.enabled = YES;
        
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isShowingCameraRoll) {
        // TODO: set how many items should be returned using ALAssets
        return 0;
    } else {
        return self.selectedImages.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Image Cell" forIndexPath:indexPath];
    
    // configure the cell
    cell.backgroundColor = [UIColor purpleColor];
    
    return cell;
}

#pragma mark - UICollectionViewFlowLayoutDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected cell %d", indexPath.row);
}

@end
