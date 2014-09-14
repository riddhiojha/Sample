//
//  ViewController.h
//  TechnicalTest
//
//  Created by Mobii_Mac on 9/5/14.
//  Copyright (c) 2014 Mobii_Mac. All rights reserved.
//

//without animation



#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "FavouritesViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

{
    IBOutlet UITableView *tableViewFeed;
    IBOutlet UIImageView *bannerImageView;
    IBOutlet UIButton *favouritesButton;
    
    NSMutableArray *dataArray;
    NSMutableArray *searchArray; //implementing the search function
//    NSMutableArray *events; // Apparently we need an array for animation
    
    
    UITableView *selectedTableView;
    
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
