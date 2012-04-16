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
@property (strong, nonatomic) NSMutableArray *inventory;
@end

@implementation DMLookupViewController

@synthesize inventory;
@synthesize delegate;

- (void)viewDidLoad
{
    self.inventory = [NSMutableArray arrayWithArray:[Food MR_findAllSortedBy:@"name" ascending:YES]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.inventory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodCell"];
	
    Food *food = [self.inventory objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Food *doomed = [self.inventory objectAtIndex:indexPath.row];
        [self.inventory removeObjectAtIndex:indexPath.row];
        [doomed MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] save:NULL];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

@end
