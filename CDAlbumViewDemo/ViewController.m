//
//  ViewController.m
//  CDAlbumViewDemo
//
//  Created by liaogang on 15/9/9.
//  Copyright (c) 2015年 liaogang. All rights reserved.
//

#import "ViewController.h"
#import "CDAlbumViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *placeHolder1;
@property (weak, nonatomic) IBOutlet UIView *placeHolder2;

@property (nonatomic,strong) CDAlbumViewController *albumViewController1;
@property (nonatomic,strong) CDAlbumViewController *albumViewController2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.placeHolder1.backgroundColor = [UIColor clearColor];
    self.placeHolder2.backgroundColor = [UIColor clearColor];
    
    
    self.albumViewController1 = [CDAlbumViewController CDAlbumWithStoryBoard];
    [self.albumViewController1 setAlbumImageUrl:[[NSBundle mainBundle] URLForResource:@"b" withExtension:@"jpg"]];
    [self.albumViewController1 addToView:self.placeHolder1];
    
    
    
    
    self.albumViewController2 = [CDAlbumViewController CDAlbumWithStoryBoard];
    [self.albumViewController2 addToView:self.placeHolder2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
