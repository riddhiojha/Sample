//
//  ViewController.m
//  TechnicalTest
//
//  Created by Mobii_Mac on 9/5/14.
//  Copyright (c) 2014 Mobii_Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize managedObjectContext;

- (void)viewDidLoad
{
    
    //Now we will fine tune the whole thing with some animations if possible
    
    
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
//    events = [[NSMutableArray alloc] init];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setTranslucent:YES];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        [self getFeedFromTwitter];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Login" message:@"Please log into Twitter through settings." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchArray.count;
    }
    else
    {
        return dataArray.count;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
    
    NSMutableDictionary *tempCellDict;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tempCellDict = [searchArray objectAtIndex:indexPath.row];
       
    } else {
        tempCellDict = [dataArray objectAtIndex:indexPath.row];
        
        
    }
    
    NSMutableDictionary *userDictionary = [tempCellDict valueForKey:@"user"];
    CGSize siezToMake = [self getSizeOfText:[tempCellDict valueForKey: @"text"] withFont:[UIFont fontWithName:@"CenturyGothic" size:11]];
    CGSize sizeForName = [self getSizeOfText:[userDictionary valueForKey: @"name"] withFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
    
    UILabel *nameOfUser = [[UILabel alloc] initWithFrame:CGRectMake(55, 8, 265, sizeForName.height) ];
    nameOfUser.text = [NSString stringWithFormat:@"@%@",[userDictionary valueForKey: @"name"]];
    [nameOfUser setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
    [nameOfUser setNumberOfLines:0];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, sizeForName.height+5, 265, siezToMake.height) ];
    titleLabel.text = [tempCellDict valueForKey: @"text"];
    //we will use here custom font for the UI
    [titleLabel setFont:[UIFont fontWithName:@"CenturyGothic" size:11]];
    [titleLabel setNumberOfLines:0]; // this is to ensure all text comes in new lines
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Added code for lazy loading
    UIImageView *feedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    NSURL *urlForImage = [NSURL URLWithString:[userDictionary valueForKey:@"profile_image_url"]];
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSMutableDictionary *tempCellDict = [searchArray objectAtIndex:indexPath.row];
        //Setting dynamic heigt according to the post
        CGSize siezToMake = [self getSizeOfText:[tempCellDict valueForKey:@"text"] withFont:[UIFont fontWithName:@"CenturyGothic" size:11]];
        
        return siezToMake.height+50;

    }
    else
    {
        NSMutableDictionary *tempCellDict = [dataArray objectAtIndex:indexPath.row];
        //Setting dynamic heigt according to the post
        CGSize siezToMake = [self getSizeOfText:[tempCellDict valueForKey:@"text"] withFont:[UIFont fontWithName:@"CenturyGothic" size:11]];
        
        return siezToMake.height+50;

        
    }

    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedTableView = self.searchDisplayController.searchResultsTableView;

        
    } else {
        selectedTableView = tableViewFeed;
        
        
    }
    UIAlertView *alertToShow = [[UIAlertView alloc] initWithTitle:@"Dubizzle" message:@"Do you want to add this to favourites?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Add to favourites", nil];
    [alertToShow setTag:indexPath.row]; // to decipher later which one to add to favourites.
    [alertToShow show];
}

#pragma mark - UIAlertView Delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   

    
    
    
    
    
    if (buttonIndex == 1) {
        NSMutableDictionary *tempCellDict;
        
        if (selectedTableView == self.searchDisplayController.searchResultsTableView) {
            tempCellDict = [searchArray objectAtIndex:alertView.tag];
            
        } else {
            tempCellDict = [dataArray objectAtIndex:alertView.tag];
            
            
        }
        
        
        
        // we will check for redundancy before adding
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"FeedDetails" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *checkArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (!checkArray.count) {
            NSManagedObject *context;
            
            NSMutableDictionary *userDictionary = [tempCellDict valueForKey:@"user"];
            
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            self.managedObjectContext = [appDelegate managedObjectContext];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedDetails" inManagedObjectContext:self.managedObjectContext];
            context = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:[self managedObjectContext]];
            [context setValue:[NSString stringWithFormat:@"@%@",[userDictionary valueForKey: @"name"]] forKey:@"name"];
            [context setValue:[userDictionary valueForKey:@"profile_image_url"] forKey:@"imageFeed"];
            [context setValue:[tempCellDict valueForKey: @"text"] forKey:@"descriptionfeed"];
            NSError *error;
            [self.managedObjectContext save:&error];
            
            
            favouritesButton.transform = CGAffineTransformMakeScale(1.7, 1.7);
            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                favouritesButton.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
            }];

        }
        else
        {
            for (int i = 0; i<checkArray.count; i++) {
                
                // We will check with description, though a bad idea, but the only option pow as we dont have a primary key.
                
                NSMutableDictionary *tempCompareDict = [checkArray objectAtIndex:i];
                if (![[tempCellDict valueForKey:@"text"] isEqualToString:[tempCompareDict valueForKey:@"descriptionfeed"]]) {
                    NSManagedObject *context;
                    
                    NSMutableDictionary *userDictionary = [tempCellDict valueForKey:@"user"];
                    
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                    self.managedObjectContext = [appDelegate managedObjectContext];
                    
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedDetails" inManagedObjectContext:self.managedObjectContext];
                    context = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:[self managedObjectContext]];
                    [context setValue:[NSString stringWithFormat:@"@%@",[userDictionary valueForKey: @"name"]] forKey:@"name"];
                    [context setValue:[userDictionary valueForKey:@"profile_image_url"] forKey:@"imageFeed"];
                    [context setValue:[tempCellDict valueForKey: @"text"] forKey:@"descriptionfeed"];
                    NSError *error;
                    [self.managedObjectContext save:&error];
                    
                    
                    favouritesButton.transform = CGAffineTransformMakeScale(1.7, 1.7);
                    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        // animate it to the identity transform (100% scale)
                        favouritesButton.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished){
                    }];
                    break;
                }
            }
            
        }

    }
}


#pragma mark - Integrating the Twitter API

- (void) getFeedFromTwitter
{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL = [NSURL URLWithString:
                                      @"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                 
                 NSDictionary *parameters =
                 @{@"screen_name" : @"@dubizzle",
                   @"count" : @"40"};
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      
//                       tableTimer=[NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(performTableUpdates:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"count", nil] repeats:YES];
                      dataArray = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                         error:&error];
                      
                      if (dataArray.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              
//                              for (int i = 0; i < [events count] ; i++) {
//                                  [self performSelector:@selector(performTableUpdates:) withObject:[NSNumber numberWithInt:i] afterDelay:i*1.5];
//                                  //Not so impressive, but works :)
//                              }
                              
                              
                              //Loading the banner image once
                              NSMutableDictionary *tempCellDict = [dataArray objectAtIndex:0];
                              NSMutableDictionary *userDictionary = [tempCellDict valueForKey:@"user"];
                              
                              NSURL *urlForImage = [NSURL URLWithString:[userDictionary valueForKey:@"profile_banner_url"]];
                              NSData *imageData = [NSData dataWithContentsOfURL:urlForImage];
                            [bannerImageView setImage:[UIImage imageWithData:imageData]];
                              
                              [tableViewFeed reloadData];
                          });
                      }
                  }];
             }
         } else {
             // Handle failure to get account access
             
         }
     }];
    
}




#pragma mark -  Get Size of text


- (CGSize)getSizeOfText:(NSString *)text withFont:(UIFont *)font
{
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(140, 500)];
//    return [text boundingRectWithSize:CGSizeMake(250, 500) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
    
   
    
}


#pragma mark - Filter search results

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchArray removeAllObjects];
    
    for (int i=0; i<[dataArray count]; i++) {
        BOOL result;
       
        NSMutableDictionary *tempCellDict = [dataArray objectAtIndex:i];
        NSString *tempDict = [tempCellDict valueForKey: @"text"];
        result = [tempDict hasPrefix:[searchText capitalizedString]];
        
        
        if ([tempDict rangeOfString:[searchText lowercaseString]].location == NSNotFound)
        {
            NSLog(@"string does not contain text");
        }
        else
        {
            result = TRUE;
             [searchArray addObject:tempCellDict];
        }
        
    }
    if ([searchText isEqualToString:@""]) {
        
        [searchArray removeAllObjects];
    }
    [tableViewFeed reloadData];

}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



#pragma mark - Present new view controller

- (IBAction)viewFavouritesController:(id)sender
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main"
                                                 bundle:nil];
    FavouritesViewController *favVc = [sb instantiateViewControllerWithIdentifier:@"favs"];
    [self presentViewController:favVc animated:YES completion:nil];
}



@end
