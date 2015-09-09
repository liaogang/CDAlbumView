//
//  CDAlbumViewController.m
//  demo
//
//  Created by liaogang on 15/9/8.
//  Copyright (c) 2015年 com.cs. All rights reserved.
//

#import "CDAlbumViewController.h"
#import "SDWebImageManager.h"


UIImage * maskImage(UIImage *image ,UIImage *maskImage );

void resumeLayer(CALayer* layer);

void pauseLayer(CALayer * layer);




@interface CDAlbumViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageCDBackgound;
@property (weak, nonatomic) IBOutlet UIImageView *imageCDFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageAlbum;

@property (nonatomic,strong) NSURL *imageURL;

@property (nonatomic) BOOL suppressedByTouch;

@end

@implementation CDAlbumViewController

+(instancetype)CDAlbumWithStoryBoard
{
    return [[UIStoryboard storyboardWithName:@"CDAlbum" bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)setAlbumFrame:(CGRect)frame
{
    CGFloat width = frame.size.width;
    CGFloat radius = width;
    
    self.imageAlbum.layer.cornerRadius = radius / 2.;
    self.imageCDFront.layer.cornerRadius = radius / 2.;
    self.imageCDBackgound.layer.cornerRadius = radius / 2.;
    
    self.imageCDFront.layer.masksToBounds = YES;
    self.imageAlbum.layer.masksToBounds = YES;
    self.imageCDBackgound.layer.masksToBounds = YES;
    
}

-(void)addToView:(UIView*)parent
{
    [self.view setFrame:parent.bounds];
    [parent addSubview:self.view];
    [self setAlbumFrame:parent.bounds];
    
    [self startAlbumRotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)initAlbumImage
{
    [[ SDWebImageManager sharedManager] downloadImageWithURL:self.imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    
        if (image && !error) {
            self.imageCDFront.hidden = YES;
            
            self.imageAlbum.hidden = NO;
            
            UIImage *mask = [UIImage imageNamed:@"cd_mask"];
            self.imageAlbum.image = maskImage(image , mask);
        }
        else
        {
            self.imageCDFront.hidden = NO;
            
            self.imageAlbum.hidden = YES;
            self.imageAlbum.image = nil;
        }
    }];

}


-(void)setAlbumImageUrl:(NSURL*)url
{
    self.imageURL = url;
    [self initAlbumImage];
}

-(void)clearAlbumImage
{
    self.imageURL = nil;
    
//    self.imageAlbum.image = nil;
//    self.imageAlbum.hidden = YES;
    
    [self initAlbumImage];
}


-(BOOL)isRotating
{
    return self.imageAlbum.layer.speed > 0.0;
}

-(void)pauseAlbumRotation
{
    self.suppressedByTouch = false;
    pauseLayer(self.imageAlbum.layer);
}

-(void)stopAlbumRotation
{
    self.suppressedByTouch = false;
    [self.imageAlbum.layer removeAllAnimations];
}

-(void)_startAlbumRotation
{
    if(![self.imageAlbum.layer animationForKey:@"rotationAnimation"] )
    {
        CFTimeInterval duration = 100 * 10 * 60 ;
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 0.15  * duration ];
        rotationAnimation.duration = duration;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 1;
        
        [self.imageAlbum.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    
    resumeLayer(self.imageAlbum.layer);
}

-(void)startAlbumRotation
{
    if([self.imageAlbum.layer animationForKey:@"rotationAnimation"] )
        [self _startAlbumRotation];
    else
        [self performSelector:@selector(_startAlbumRotation) withObject:nil afterDelay:0.9];
}


#pragma mark - touches

-(void)imageTouchesEnded
{
    if (self.suppressedByTouch ) {
        [self _startAlbumRotation];
        self.suppressedByTouch = false;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isRotating]) {
        [self pauseAlbumRotation];
        self.suppressedByTouch = true;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self imageTouchesEnded];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self imageTouchesEnded];
}

@end







void pauseLayer(CALayer * layer)
{
    if (layer.speed > 0.0)
    {
        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.speed = 0.0;
        layer.timeOffset = pausedTime;
    }
}

void resumeLayer(CALayer* layer)
{
    if (layer.speed == 0.0)
    {
        CFTimeInterval pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
    }
}


UIImage * maskImage(UIImage *image ,UIImage *maskImage )
{
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}
