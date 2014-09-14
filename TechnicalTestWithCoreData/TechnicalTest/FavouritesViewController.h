//
//  FavouritesViewController.h
//  TechnicalTest
//
//  Created by Mobii_Mac on 9/14/14.
//  Copyright (c) 2014 Mobii_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface FavouritesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *dataArray;
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;


@end
