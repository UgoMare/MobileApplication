//
//  ViewController.m
//  MobileApplication
//
//  Created by Ugo on 11/12/2014.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MobileCollectionViewCell.h"
#import "EditViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    AppDelegate *appDelegate;
    UIImage *imageForEditing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageForEditing = [[UIImage alloc] init];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MobileCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(self.view.bounds.size.width, 80);
}


// header view data source

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    
    return headerView;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return appDelegate.pictures.count;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

        return [self MobileCellForIndexPath:indexPath];
}

- (UICollectionViewCell *)MobileCellForIndexPath:(NSIndexPath *)indexPath{
    MobileCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setupCell:[appDelegate.pictures objectAtIndex:indexPath.row]];
    
    return cell;
}



-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   imageForEditing = [appDelegate.pictures objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showPictureDetail" sender:self];
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPictureDetail"]) {
        
        EditViewController *editVc = [segue destinationViewController];
        
        editVc.imageToEdit = [[UIImage alloc]init];
        editVc.imageToEdit = imageForEditing;
        
        
    }
}




-(IBAction)takePicture:(id)sender
{
    [self performSegueWithIdentifier:@"takePicture" sender:self];
}
@end
