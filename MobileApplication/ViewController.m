//
//  ViewController.m
//  MobileApplication
//
//  Created by Ugo on 11/12/2014.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.imageTaken != nil)
    {
        self.imageView.image = self.imageTaken;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

-(IBAction)takePicture:(id)sender
{
    [self performSegueWithIdentifier:@"takePicture" sender:self];
}
@end
