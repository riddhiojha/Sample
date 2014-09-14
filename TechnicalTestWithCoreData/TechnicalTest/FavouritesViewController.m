//
//  FavouritesViewController.m
//  TechnicalTest
//
//  Created by Mobii_Mac on 9/14/14.
//  Copyright (c) 2014 Mobii_Mac. All rights reserved.
//

#import "FavouritesViewController.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FeedDetails" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    dataArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%@", dataArray);
    self.title = @"Favourites";
    
        

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    return dataArray.count;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
    
    NSMutableDictionary *tempCellDict;
    
        tempCellDict = [dataArray objectAtIndex:indexPath.row];
        
    
    
    CGSize siezToMake = [self getSizeOfText:[tempCellDict valueForKey: @"descriptionfeed"] withFont:[UIFont fontWithName:@"CenturyGothic" size:11]];
    CGSize sizeForName = [self getSizeOfText:[tempCellDict valueForKey: @"name"] withFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
    
    UILabel *nameOfUser = [[UILabel alloc] initWithFrame:CGRectMake(55, 8, 265, sizeForName.height) ];
    nameOfUser.text = [NSString stringWithFormat:@"%@",[tempCellDict valueForKey: @"name"]];
    [nameOfUser setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
    [nameOfUser setNumberOfLines:0];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, sizeForName.height+5, 265, siezToMake.height) ];
    titleLabel.text = [tempCellDict valueForKey: @"descriptionfeed"];
    //we will use here custom font for the UI
    [titleLabel setFont:[UIFont fontWithName:@"CenturyGothic" size:11]];
    [titleLabel setNumberOfLines:0]; // this is to ensure all text comes in new lines
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Added code for lazy loading
    UIImageView *feedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    NSURL *urlForImage = [NSURL URLWithString:[tempCellDict valueForKey:@"imageFeed"]];
    [feedImageView setImageWithURL:urlForImage placeholderImage:[UIImage imageNamed:@""]];;
    [feedImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    //Adding the labels and Images to the cell content view
    [cell.contentView addSubview:nameOfUser];
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:feedImageView];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //also putting the condition here as dynamic height is implemented for all cells    
        NSMutableDictionary *tempCellDict = [dataArray objectAtIndex:indexPath.row];
        //Setting dynamic heigt according to the post
        CGSize siezToMake = [self getSizeOfText:[tempCellDict valueForKey:@"descriptionfeed"] withFont:[UIFont fontWithName:@"CenturyGothic" size:11]];
        
        return siezToMake.height+50;
    
}
#pragma mark -  Get Size of text


- (CGSize)getSizeOfText:(NSString *)text withFont:(UIFont *)font
{
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(140, 500)];
    //    return [text boundingRectWithSize:CGSizeMake(250, 500) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
    
    
    
}





@end
