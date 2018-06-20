//
//  DKViewController.m
//  DKFavoriteButton
//
//  Created by drinking on 06/20/2018.
//  Copyright (c) 2018 drinking. All rights reserved.
//

#import "DKViewController.h"
#import <DKFavoriteButton/DKFavoriteButton.h>

@interface DKViewController ()

@property(nonatomic,strong) DKFavoriteButton *button;
@property(nonatomic,strong) UIButton *triggerButton;
@end

@implementation DKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.button = [[DKFavoriteButton alloc] initWithFrame:CGRectMake(100, 100, 44, 44) image:[UIImage imageNamed:@"share_star_selected"]];
    [self.view addSubview:self.button];
    
    self.triggerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 60, 44)];
    [self.triggerButton setTitle:@"trigger" forState:UIControlStateNormal];
    [self.triggerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.triggerButton];
    [self.triggerButton addTarget:self action:@selector(trigger) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)trigger {
    if(self.button.selected) {
        [self.button deselect];
    }else {
        [self.button select];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
