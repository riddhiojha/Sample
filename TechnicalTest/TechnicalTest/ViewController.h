//
//  ViewController.h
//  TechnicalTest
//
//  Created by Mobii_Mac on 9/5/14.
//  Copyright (c) 2014 Mobii_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "UIImageView+AFNetworking.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

{
    IBOutlet UITableView *tableViewFeed;
    IBOutlet UIImageView *bannerImageView;
    
    NSMutableArray *dataArray;
    NSMutableArray *searchArray; //implementing the search function
    
}

@end
