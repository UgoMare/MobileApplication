//
//  CameraOverlayViewController.m
//  MobileApplication
//
//  Created by Leo Martin on 12/11/14.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CameraOverlayViewController.h"
#import "FiltersViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraOverlayViewController ()

@end

@implementation CameraOverlayViewController
{
    float diff;
    AppDelegate *appDelegate;
    UIButton *flashmodeButton;
    ALAssetsLibrary* library;
}
#define GO_TO_LIBRARY_TAG 99
#define SHOW_FILTERS_TAG  98

- (void)viewDidLoad {
    [super viewDidLoad];
    library = [[ALAssetsLibrary alloc] init];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            _imagePicker.showsCameraControls = NO;
            _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            _imagePicker.allowsEditing = NO;
            
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
//    [overlayView setBackgroundColor:[UIColor colorWithRed:9 green:116 blue:184 alpha:1]];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.78];
    
    
    UIImage *goBackImg = [UIImage imageNamed:@"arrow-nav-blue.png"];
    UIButton *goBackButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:goBackImg forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(cancelTakePicture) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setFrame:CGRectMake(0, 22, 60, 40)];
    [goBackButton setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,30)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 136, 23)];
    titleLabel.text = NSLocalizedStringFromTable(@"Take Picture", @"LocalizedStrings", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:9/255.0f green:116/255.0f blue:184/255.0f alpha:1];
    [navigationView addSubview:titleLabel];
    [navigationView addSubview:goBackButton];
    
    UIView *bottomNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, 320, self.view.frame.size.height - 380)];
    bottomNavigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.78];
    
    [overlayView addSubview:navigationView];
    [overlayView addSubview:bottomNavigationView];

    
    UIImage *takePictureImg = [UIImage imageNamed:@"bttn-take-picture.png"];
    
    UIButton *takePictureButton = [UIButton
                                   buttonWithType:UIButtonTypeCustom];
    [takePictureButton setImage:takePictureImg forState:UIControlStateNormal];
    [takePictureButton addTarget:self action:@selector(snapPicture) forControlEvents:UIControlEventTouchUpInside];
    [takePictureButton setFrame:CGRectMake(122, 380 + bottomNavigationView.frame.size.height/2 - 38 + diff, 77, 77)];
    
    takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    [overlayView addSubview:takePictureButton];
    
    UIImage *switchCameraImg = [UIImage imageNamed:@"switch-camera-button.png"];
    
    UIButton *switchCameraButton = [UIButton
                                    buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:switchCameraImg forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(248, 65, 52, 52)];
    [switchCameraButton setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,0)];
    
    UIImage *flashModeImg = [UIImage imageNamed:@"flash-mode-button.png"];
    UIImage *noFlashModeImg = [UIImage imageNamed:@"no-flash-mode-button.png"];
    
    flashmodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashmodeButton setImage:noFlashModeImg forState:UIControlStateNormal];
   [flashmodeButton setImage:flashModeImg forState:UIControlStateSelected];
    [flashmodeButton addTarget:self action:@selector(flashMode) forControlEvents:UIControlEventTouchUpInside];
    [flashmodeButton setFrame:CGRectMake(20, 75, 15, 34)];
    
    
    [overlayView addSubview:switchCameraButton];
    [overlayView addSubview:flashmodeButton];
    
    [self addGoToLibraryButton:[UIImage imageNamed:@"gallery-button.png"] toView:overlayView];
       _imagePicker.cameraOverlayView = overlayView;
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
    [goToLibrary addTarget:self action:@selector(switchCameraSourceType) forControlEvents:UIControlEventTouchUpInside];
    float topPos = 375 + (self.view.frame.size.height - 380)/2 - 44/2 + diff;
    [goToLibrary setFrame:CGRectMake(20, topPos, 60, 60)];
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

-(void)flashMode
{
    if (_imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff)
    {
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        [flashmodeButton setSelected:YES];
    }
    else {
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        [flashmodeButton setSelected:NO];
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
    
}

- (UIImage *)squareCropImage:(UIImage *)sourceImage ToSideLength:(CGFloat)sideLength
{
    // input size comes from image
    CGSize inputSize = sourceImage.size;
    
    // round up side length to avoid fractional output size
    sideLength = ceilf(sideLength);
    
    // output size has sideLength for both dimensions
    CGSize outputSize = CGSizeMake(sideLength, sideLength);
    
    // calculate scale so that smaller dimension fits sideLength
    CGFloat scale = MAX(sideLength / inputSize.width,
                        sideLength / inputSize.height);
    
    // scaling the image with this scale results in this output size
    CGSize scaledInputSize = CGSizeMake(inputSize.width * scale,
                                        inputSize.height * scale);
    
    // determine point in center of "canvas"
    CGPoint center = CGPointMake(outputSize.width/2.0,
                                 outputSize.height/2.0);
    
    // calculate drawing rect relative to output Size
    CGRect outputRect = CGRectMake(center.x - scaledInputSize.width/2.0,
                                   center.y - scaledInputSize.height/2.0,
                                   scaledInputSize.width,
                                   scaledInputSize.height);
    
    // begin a new bitmap context, scale 0 takes display scale
    UIGraphicsBeginImageContextWithOptions(outputSize, YES, 0);
    
    // optional: set the interpolation quality.
    // For this you need to grab the underlying CGContext
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    // draw the source image into the calculated rect
    [sourceImage drawInRect:outputRect];
    
    // create new image from bitmap context
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up
    UIGraphicsEndImageContext();
    
    // pass back new image
    return outImage;
}


-(void) setupImageForFilters
{
    
    self.imageTaken = [self squareCropImage:self.imageTaken ToSideLength:320];
    [self performSegueWithIdentifier:@"addFilters" sender:nil];
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"addFilters"]) {
        
        FiltersViewController *filtersVc = [segue destinationViewController];
        
        filtersVc.originalImage = self.imageTaken;
    }
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
