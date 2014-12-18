//
//  MobileCollectionViewCell.m
//  MobileApplication
//
//  Created by Leo Martin on 12/18/14.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import "MobileCollectionViewCell.h"

@implementation MobileCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setupCell:(UIImage*)anImage; {
    
    self.imageView.image = anImage;
}

@end
