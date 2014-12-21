//
//  FiltersViewController.h
//  MobileApplication
//
//  Created by Leo Martin on 12/21/14.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAssetsLibrary-CustomPhotoAlbum/ALAssetsLibrary+CustomPhotoAlbum.h"


@interface FiltersViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic) UIImage* originalImage;
@property (nonatomic) IBOutlet UIImageView *previewImg;
@end
