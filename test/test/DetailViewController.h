//
//  DetailViewController.h
//  test
//
//  Created by Mobii_Mac on 9/3/14.
//  Copyright (c) 2014 Mobii_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
