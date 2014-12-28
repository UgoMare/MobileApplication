//
//  FiltersViewController.m
//  MobileApplication
//
//  Created by Leo Martin on 12/21/14.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import "FiltersViewController.h"
#import "UIImage+Filters.h"
#import "AppDelegate.h"
@interface FiltersViewController ()


@end

@implementation FiltersViewController
{
    UIImage *output;
    AppDelegate *appDelegate;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    output = self.originalImage;
    self.previewImg.image = output;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addFilter:(id)sender
{
    [self showFiltersMenu];
}
-(void)showFiltersMenu {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"LocalizedStrings", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  NSLocalizedStringFromTable(@"Sepia", @"LocalizedStrings", nil),
                                  NSLocalizedStringFromTable(@"Used", @"LocalizedStrings", nil),
                                    NSLocalizedStringFromTable(@"Black & White", @"LocalizedStrings", nil),
                                  NSLocalizedStringFromTable(@"No filter", @"LocalizedStrings", nil),nil];
    
    
    
    
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) [self sepiaFilter];
    if (1 == buttonIndex) [self usedFilter];
    if (2 == buttonIndex) [self bwFilter];
    if (3 == buttonIndex) [self noFilter];
    if (4 == buttonIndex) return; // it's the cancel button
}



-(void)noFilter{
    self.previewImg.image = self.originalImage;
    output = self.previewImg.image;
}

-(void)sepiaFilter{
    
    self.previewImg.image = [self.originalImage toSepia];
    
    output = self.previewImg.image;
}


-(void)bwFilter
{
    self.previewImg.image = [self.originalImage CIPhotoEffectNoir];
    output = self.previewImg.image;
}
-(void) usedFilter{
    self.previewImg.image = [self.originalImage vintageFilter];
    
    output = self.previewImg.image;
}

-(IBAction)doneWithPicture:(id)sender
{
    [appDelegate.pictures addObject:output];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(output, nil, nil, nil);
        
    });

    [self.navigationController popToRootViewControllerAnimated:YES];
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
