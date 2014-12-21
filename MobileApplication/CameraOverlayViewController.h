//
//  CameraOverlayViewController.h
//  MobileApplication
//
//  Created by Leo Martin on 12/11/14.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage.h>

@interface CameraOverlayViewController : UIViewController <UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic) UIImagePickerController *imagePicker;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) IBOutlet UIButton *takePictureButton;
@property (nonatomic) UIImage *imageTaken;

@end
