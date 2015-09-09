//
//  CDAlbumViewController.h
//  demo
//
//  Created by liaogang on 15/9/8.
//  Copyright (c) 2015年 com.cs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDAlbumViewController : UIViewController

+(instancetype)CDAlbumWithStoryBoard;

//-(void)setAlbumFrame:(CGRect)frame;

-(void)addToView:(UIView*)parent;

-(void)setAlbumImageUrl:(NSURL*)url;

-(void)clearAlbumImage;


-(void)pauseAlbumRotation;

-(void)startAlbumRotation;

-(BOOL)isRotating;

@end

