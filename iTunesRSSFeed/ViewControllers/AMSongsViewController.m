//
//  AMSongsViewController.m
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMSongsViewController.h"
#import "AMSongsLibrary.h"
#import "AMDataStore.h"
#import "Songs.h"
#import "AMAlbumArtViewController.h"
#import "AMDataConnection.h"

#define LOADING_MESSAGE @"Loding...";
#define TITLE @"Top Songs";

@implementation AMSongsViewController
{
    NSMutableArray *_songsList;
    NSOperationQueue *_backGroundQueue;
    AMDataConnection *_dataConnection;
    NSCache *_imageCash;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = TITLE;
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(refreshView)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:FINISH_DOWNLOAD_XML
                                               object:nil];
    _imageCash = [[NSCache alloc] init];
    _dataConnection = [[AMDataConnection alloc] initWithURL:[NSURL URLWithString:RSS_URL]];
    _dataConnection.dataStore = self.dataStore;
    
    _backGroundQueue = [[NSOperationQueue alloc] init];
    [_backGroundQueue setName:@"com.itunesRSSFeed.imageDownloadQuese"];
    [self refreshView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_backGroundQueue cancelAllOperations];
}

/* This method refill the songslink and refresh table view */
- (void)refreshView
{
    if (!_songsList)
    {
        _songsList = [[NSMutableArray alloc] init];
    }
    
    [_songsList removeAllObjects];
    [_songsList addObjectsFromArray:[self.dataStore.songsLibrary getAllSongs]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [_imageCash removeAllObjects];
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_songsList.count == 0 ? 1 : _songsList.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
    }
    
    if (_songsList.count > 0)
    {
        //place holder image is use until the image is download from the web.
        cell.imageView.image = [UIImage imageNamed:IMAGE_PLACE_HOLDER];
        Songs *song = [_songsList objectAtIndex:indexPath.row];
        cell.textLabel.text =  [song title];
        
        __block NSURL *imageURL;
        __block NSData *imageData;
        
        if ([_imageCash objectForKey:song.title])
        {
            cell.imageView.image = [_imageCash objectForKey:song.title];
        }
        else
        {
           [_backGroundQueue addOperationWithBlock:^{
                imageURL = [NSURL URLWithString:[song albumImageSmall]];
                imageData = [NSData dataWithContentsOfURL:imageURL];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIImage *image = [UIImage imageWithData:imageData];
                    [_imageCash setObject:image forKey:song.title];
                    [tableView cellForRowAtIndexPath:indexPath].imageView.image = image;
                }];
            }];
        }
    }
    else
    {
        cell.textLabel.text = LOADING_MESSAGE;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMAlbumArtViewController *albumArtViewController = [[AMAlbumArtViewController alloc] init];
    albumArtViewController.song = [_songsList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:albumArtViewController animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
