//
//  AMXMLHandler.m
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 9/28/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import "AMXMLHandler.h"
#import "Songs.h"
#import "AMSongsLibrary.h"
#import "AMDataStore.h"
#import "AMCoreDataManager.h"

#define TIME_FORMAT @"yyyy-MM-dd'T'hh:mm:ss"
#define kLAST_UPDATE_TIME @"lastUpdateTime"
#define LARGE_IMAGE_SIZE @"170"
#define SMALL_IMAGE_SIZE @"60"

static NSString *nameTitle = @"title";
static NSString *item = @"entry";
static NSString *albumImageURL = @"im:image";
static NSString *songId = @"id";
static NSString *updated = @"updated";
static NSString *heightAttr = @"height";

@implementation AMXMLHandler
{
    NSXMLParser *_xmlPraser;
    NSMutableString *_currentString;
    BOOL isSongTitleEditing;
    BOOL isSmallImage;
    BOOL isLargeImage;
    BOOL _newUpdatesAvalable;
    BOOL _updateChecked;
    Songs *_song;
}

- (id)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        _currentString = [[NSMutableString alloc] init];
        _xmlPraser = [[NSXMLParser alloc] initWithData:data];
        _xmlPraser.delegate = self;
        isSongTitleEditing = NO;
        isSmallImage = NO;
        isLargeImage = NO;
        _newUpdatesAvalable = NO;
        _updateChecked = NO;
    }
    
    return self;
}

- (BOOL)prase
{
    return [_xmlPraser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (_newUpdatesAvalable)
    {
        if ([elementName isEqualToString:item])
        {
            _song = [self.dataStore.songsLibrary getNewEntityByType:NSStringFromClass([Songs class])];
        }
        else if ([elementName isEqualToString:nameTitle]
                 || [elementName isEqualToString:songId]
                 || [elementName isEqualToString:albumImageURL])
        {
            if ([[attributeDict objectForKey:heightAttr] isEqualToString:SMALL_IMAGE_SIZE])
            {
                isLargeImage = NO;
                isSmallImage = YES;
            }
            else if ([[attributeDict objectForKey:heightAttr] isEqualToString:LARGE_IMAGE_SIZE])
            {
                isSmallImage = NO;
                isLargeImage = YES;
            }
            
            [_currentString setString:@""];
            isSongTitleEditing = YES;
        }
    }
    else if ([elementName isEqualToString:updated])
    {
        [_currentString setString:@""];
        isSongTitleEditing = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:nameTitle])
    {
        if (_song)
        {
            _song.title = [NSString stringWithString:_currentString];;
        }
    }
    else if ([elementName isEqualToString:albumImageURL])
    {
        if (_song)
        {
            if (isLargeImage)
            {
                _song.albumImageLarge = [NSString stringWithString:_currentString];;
                isLargeImage = NO;
            }
            else if (isSmallImage)
            {
                _song.albumImageSmall = [NSString stringWithString:_currentString];;
                isSmallImage = NO;
            }
        }
    }
    else if ([elementName isEqualToString:songId])
    {
        if (_song)
        {
            _song.webLink = [NSString stringWithString:_currentString];
        }
    }
    else if ([elementName isEqualToString:updated] && !_updateChecked)
    {
        _updateChecked = YES;
        NSString *newTimeString = [NSString stringWithString:_currentString];
        NSString *oldTimeString = [[NSUserDefaults standardUserDefaults] valueForKey:kLAST_UPDATE_TIME];
        
        NSDateFormatter *dateFormatterNewTime = [[NSDateFormatter alloc] init];
        NSDateFormatter *dateFormatterOldTime = [[NSDateFormatter alloc] init];
        [dateFormatterNewTime setDateFormat:TIME_FORMAT];
        [dateFormatterOldTime setDateFormat:TIME_FORMAT];
        
        NSDate *lastUpdateDate = [dateFormatterOldTime dateFromString:oldTimeString];
        NSDate *newUpdateDate = [dateFormatterNewTime dateFromString:newTimeString];
        
        if (oldTimeString == nil || [lastUpdateDate compare:newUpdateDate] == NSOrderedAscending)
        {
            [[NSUserDefaults standardUserDefaults] setValue:newTimeString forKey:kLAST_UPDATE_TIME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _newUpdatesAvalable = YES;
            [self.dataStore.songsLibrary removeAllObjectsInEntity:NSStringFromClass([Songs class])];
        }
        else
        {
            [_xmlPraser abortParsing];
        }
    }
    
     [_currentString setString:@""];
    isSongTitleEditing = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isSongTitleEditing)
    {
        [_currentString appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.dataStore.coreDataManager saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:FINISH_DOWNLOAD_XML object:nil];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (parseError.code != NSXMLParserDelegateAbortedParseError)
    {
        NSString *errorString = [parseError localizedDescription];
        UIAlertView *xmlParserErrorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [xmlParserErrorMessage show];
    }
}

@end
