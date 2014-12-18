//
//  MobileCollectionViewCell.h
//  MobileApplication
//
//  Created by Leo Martin on 12/18/14.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

-(void)setupCell:(UIImage*)anImage;

@end
