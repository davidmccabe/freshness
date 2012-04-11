//
//  DMSecondViewController.m
//  Lastid
//
//  Created by David McCabe on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DMLookupViewController.h"
#import "Food.h"

@interface DMLookupViewController ()

@end

@implementation DMLookupViewController

@synthesize delegate;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Food MR_countOfEntities];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodCell"];
	
    Food *food = [[Food MR_findAllSortedBy:@"lastAdded" ascending:YES] objectAtIndex:indexPath.row];
	cell.textLabel.text = food.name;
	cell.detailTextLabel.text = [self labelStringForDate:food.lastAdded];
    
    return cell;
}

- (NSString *)labelStringForDate:(NSDate *)theDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dMMM" options:0 locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:formatString];

    return [dateFormatter stringFromDate:theDate];
}

- (IBAction)addFoodsPressed:(UIBarButtonItem *)sender
{
    [self.delegate lookupViewControllerDidFinish:self];
}
@end
