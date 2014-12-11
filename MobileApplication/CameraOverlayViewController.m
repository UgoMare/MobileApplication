//
//  CameraOverlayViewController.m
//  MobileApplication
//
//  Created by Leo Martin on 12/11/14.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import "ViewController.h"
#import "CameraOverlayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraOverlayViewController ()

@end

@implementation CameraOverlayViewController
{
    float diff;
}
#define GO_TO_LIBRARY_TAG 99

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupImagePicker];
}

-(void) setupImagePicker {
    
    if(!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        [_imagePicker setDelegate:self];
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            _imagePicker.showsCameraControls = NO;
            _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            _imagePicker.allowsEditing = YES;
            
            diff = 0; //(self.view.frame.size.height - self.view.frame.size.width / 3 * 4)/2;
            
            [self initOverlayView];
            NSLog(@"diff %f", diff);
            
        } else {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imagePicker.allowsEditing = YES;
        }
    }
    if(![self.presentedViewController isEqual:_imagePicker]) {
        [self presentViewController:_imagePicker animated:NO completion:nil];
    }
}



-(void) initOverlayView
{
    
    UIView *overlayView = [[UIView alloc] init];
    
    overlayView.frame =  _imagePicker.cameraOverlayView.frame;
    
    _imagePicker.cameraOverlayView = overlayView;
}


-(void) addLastPictureFromLibrary {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                     if (nil != group) {
                                         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         
                                         if(group.numberOfAssets > 0) {
                                             [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets - 1]
                                                                     options:0
                                                                  usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                                      if (nil != result) {
                                                                          ALAssetRepresentation *repr = [result defaultRepresentation];
                                                                          // this is the most recent saved photo
                                                                          UIImage *img = [UIImage imageWithCGImage:[repr fullResolutionImage]];
                                                                          [self addGoToLibraryButton:img toView:_imagePicker.cameraOverlayView];
                                                                          // we only need the first (most recent) photo -- stop the enumeration
                                                                          *stop = YES;
                                                                      }
                                                                  }];
                                         }
                                     }
                                     
                                     *stop = NO;
                                 } failureBlock:^(NSError *error) {
                                     NSLog(@"error: %@", error);
                                 }];
    
    
}

-(void)addGoToLibraryButton:(UIImage *)img toView:(UIView *)cameraOverlayView {
    UIButton *goToLibrary = [UIButton buttonWithType:UIButtonTypeCustom];
    if(img == nil) {
        [goToLibrary setBackgroundColor:[UIColor whiteColor]];
    } else {
        [goToLibrary setImage:img forState:UIControlStateNormal];
    }
    goToLibrary.layer.cornerRadius = 5;
    goToLibrary.layer.masksToBounds = YES;
    goToLibrary.layer.borderWidth = 1;
    goToLibrary.layer.borderColor = [UIColor whiteColor].CGColor;
    [goToLibrary addTarget:self action:@selector(switchCameraSourceType) forControlEvents:UIControlEventTouchUpInside];
    float topPos = 380 + (self.view.frame.size.height - 380)/2 - 44/2 + diff;
    [goToLibrary setFrame:CGRectMake(20, topPos, 44, 44)];
    goToLibrary.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    for (UIView *subView in cameraOverlayView.subviews) {
        if (subView.tag == GO_TO_LIBRARY_TAG) [subView removeFromSuperview];
    }
    goToLibrary.tag = GO_TO_LIBRARY_TAG;
    [cameraOverlayView addSubview:goToLibrary];
}

- (void)switchCamera
{
    if (_imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else
    {
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

-(void) switchCameraSourceType
{
    [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

-(void)snapPicture
{
    [_imagePicker takePicture];
}

-(void) cancelTakePicture
{
    NSLog(@"CANCEL");
    [self.navigationController popViewControllerAnimated:YES];
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
        [self SetImageTakenForSegue:info];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)SetImageTakenForSegue:(NSDictionary*) info
{
    if([info valueForKey:UIImagePickerControllerEditedImage]) {
        self.imageTaken = [info valueForKey:UIImagePickerControllerEditedImage];
    } else {
        self.imageTaken = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    if( _imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera
       && _imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        self.imageTaken = [UIImage imageWithCGImage:self.imageTaken.CGImage scale:self.imageTaken.scale orientation:UIImageOrientationLeftMirrored];
    }
    
    [self setupImageForFilters];
    
    [self.navigationController popViewControllerAnimated:YES];
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void) setupImageForFilters
{
    ViewController *viewController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    viewController.imageTaken = self.imageTaken;
    
    
    [self.navigationController popViewControllerAnimated:YES];
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
