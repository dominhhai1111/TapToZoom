//
//  ViewController.m
//  TapToZoom
//
//  Created by Do Minh Hai on 11/4/15.
//  Copyright (c) 2015 Do Minh Hai. All rights reserved.
//

#import "ViewController.h"
#define ZOOM_STEP 1.5
@interface ViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property(weak, nonatomic) UIScrollView* scrollView;
@property(weak, nonatomic) UIImageView* photo;
@property(weak, nonatomic) UILabel* scaleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.1;
    scrollView.maximumZoomScale = 10.0;
    scrollView.zoomScale = 1.0;
    scrollView.clipsToBounds =true;
    
    UIImageView* photo = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    photo.image = [UIImage imageNamed:@"minions.jpeg"];
    photo.contentMode = UIViewContentModeScaleAspectFit;
    photo.userInteractionEnabled = true;
    photo.multipleTouchEnabled = true;

    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(onSingleTap:)];
    singleTap.numberOfTapsRequired = 1 ;
    singleTap.delegate = self;
    [photo addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(onDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2 ;
    doubleTap.delegate = self;
    [photo addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [scrollView addSubview:photo];
    [self.view addSubview:scrollView];
    
    self.photo = photo;
    self.scrollView = scrollView;
    
    UIView* NaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    // cach 1 (add vao navigation)
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 50)];
    titleLabel.center = CGPointMake(self.view.bounds.size.width/2, 30);
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"UIScrollView";
    [NaviView addSubview:titleLabel];
    // cach 2
    UILabel* scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    scaleLabel.textAlignment = NSTextAlignmentRight;
    scaleLabel.text = [NSString stringWithFormat:@"%2.2f",scrollView.zoomScale];
    
    UIBarButtonItem* barButton= [[UIBarButtonItem alloc]initWithCustomView:scaleLabel ];
    [self.navigationItem setRightBarButtonItem:barButton];
    self.scaleLabel =scaleLabel;
    
    self.navigationItem.titleView = NaviView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photo;
}


-(void) onSingleTap: (UITapGestureRecognizer*) singleTap
{
    CGPoint tapPoint = [singleTap locationInView:self.photo];
    float newScale = self.scrollView.zoomScale * ZOOM_STEP;
    [self zoomRectForScale: newScale
                withCenter: tapPoint];
}

-(void) onDoubleTap: (UITapGestureRecognizer*) doubleTap
{
    CGPoint tapPoint = [doubleTap locationInView:self.photo];
    float newScale = self.scrollView.zoomScale / ZOOM_STEP;
    [self zoomRectForScale: newScale
                withCenter: tapPoint];
}
- (void)zoomRectForScale:(float)scale
              withCenter:(CGPoint)center {
    CGRect zoomRect;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    zoomRect.size.height = scrollViewSize.height / scale;
    zoomRect.size.width  = scrollViewSize.width  / scale;
    
   
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    [self.scrollView zoomToRect:zoomRect
                       animated:YES];
    
    self.scaleLabel.text = [NSString stringWithFormat:@"%2.2f", self.scrollView.zoomScale];
    
}@end
