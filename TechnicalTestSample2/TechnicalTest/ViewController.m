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

- (void)viewDidLoad
{
    
    //Now we will fine tune the whole thing with some animations if possible
    
    
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    events = [[NSMutableArray alloc] init];
    [self getFeedFromTwitter];// Do any additional setup after loading the view, typically from a nib.
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
                      events = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                         error:&error];
                      
                      if (events.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              
                              for (int i = 0; i < [events count] ; i++) {
                                  [self performSelector:@selector(performTableUpdates:) withObject:[NSNumber numberWithInt:i] afterDelay:i*1.5];
                                  //Not so impressive, but works :)
                              }
                              
                              
                              //Loading the banner image once
                              NSMutableDictionary *tempCellDict = [events objectAtIndex:0];
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


#pragma mark - Animation for fun ;)

-(void)performTableUpdates:(id )intVariable
{
    int i = [intVariable intValue];
    NSLog(@"%i",i);
    NSIndexPath *ip=[NSIndexPath indexPathForRow:i inSection:0];
    [dataArray addObject:[events objectAtIndex:i]];
    [tableViewFeed beginUpdates];
    [tableViewFeed insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationLeft];
    [tableViewFeed endUpdates];
    
    if(i<[events count])
    {
        if([events count]-i==1)
        {
            i++;
        }
        else
            i++;
    }
}




@end
