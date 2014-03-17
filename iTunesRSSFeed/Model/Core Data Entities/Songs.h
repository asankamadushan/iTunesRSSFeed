//
//  Songs.h
//  iTunesRSSFeed
//
//  Created by Asanka Perera on 10/1/13.
//  Copyright (c) 2013 Asanka Perera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Songs : NSManagedObject

@property (nonatomic, retain) NSString * albumImageLarge;
@property (nonatomic, retain) NSString * albumImageSmall;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * webLink;

@end
