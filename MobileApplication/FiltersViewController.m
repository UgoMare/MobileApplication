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
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    output = self.originalImage;
    self.previewImg.image = output;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
                                  NSLocalizedStringFromTable(@"No filter", @"LocalizedStrings", nil),nil];
    
    
    
    
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) [self sepiaFilter];
    if (1 == buttonIndex) [self usedFilter];
    if (2 == buttonIndex) [self noFilter];
    if (3 == buttonIndex) return; // it's the cancel button
}



-(void)noFilter{
    self.previewImg.image = self.originalImage;
    output = self.previewImg.image;
}

-(void)sepiaFilter{
    
    self.previewImg.image = [self.originalImage toSepia];
    
    output = self.previewImg.image;
}

-(void) usedFilter{
    self.previewImg.image = [self.originalImage vintageFilter];
    
    output = self.previewImg.image;
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
