//
//  AMAlbumArtViewController.h
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 10/1/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

@class Songs;

@interface AMAlbumArtViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) Songs *song;

@end
