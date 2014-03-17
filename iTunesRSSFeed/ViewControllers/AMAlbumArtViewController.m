//
//  AMAlbumArtViewController.m
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 10/1/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMAlbumArtViewController.h"
#import "AMDataStore.h"
#import "Songs.h"

#define ALBUM_ARL_HEIGHT 170
#define ALBUM_ARL_WIDTH 170
#define MAX_ZOOM_SCALE 4.0
#define MIN_ZOOM_SCALE 0.5

@implementation AMAlbumArtViewController
{
    UIScrollView *_scrollView;
    __block UIImageView *_albumArt;
    NSOperationQueue *_backGroundQueue;
    UIActivityIndicatorView *_lodingIndicator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"Album Art - %@", self.song.title];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.center = self.view.center;
    _scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    _scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    
    _albumArt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_PLACE_HOLDER]];
    _albumArt.frame = CGRectMake((self.view.frame.size.width / 2) - (ALBUM_ARL_WIDTH / 2),
                                 (self.view.frame.size.height / 2) - ALBUM_ARL_HEIGHT, ALBUM_ARL_WIDTH, ALBUM_ARL_HEIGHT);
    
    _albumArt.userInteractionEnabled = YES;
    _scrollView.contentSize = _albumArt.frame.size;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapOnImage)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    [_albumArt addGestureRecognizer:tapGesture];
    [_scrollView addSubview:_albumArt];
    
    _lodingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_albumArt.frame.origin.x + 30,
                                                                                 _albumArt.frame.origin.y + (ALBUM_ARL_HEIGHT / 2),
                                                                                 100,
                                                                                 100)];
    
    _lodingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_lodingIndicator];
    _backGroundQueue = [[NSOperationQueue alloc] init];
    [self downloadAndSetImage];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_backGroundQueue cancelAllOperations];
}

- (void)downloadAndSetImage
{
    __block NSData *imageData;
    
    [_lodingIndicator startAnimating];
    
    [_backGroundQueue addOperationWithBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURL *imageURL = [NSURL URLWithString:self.song.albumImageLarge];
        imageData = [NSData dataWithContentsOfURL:imageURL];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             _albumArt.image = [UIImage imageWithData:imageData];
            [_lodingIndicator stopAnimating];
            [_lodingIndicator removeFromSuperview];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _albumArt;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    view.center = self.view.center;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [UIView animateWithDuration:0.3 animations:^{
         _albumArt.center = self.view.center;
    }];
}

/* This method open a url on tap event through iTunes */
- (void)tapOnImage
{
    NSURL *iTuneURL = [NSURL URLWithString:self.song.webLink];
    if ([[UIApplication sharedApplication] canOpenURL:iTuneURL])
    {
        [[UIApplication sharedApplication] openURL:iTuneURL];
    }
}

@end
