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
@property (strong, nonatomic) NSFetchedResultsController *frc;
@end

@implementation DMLookupViewController

@synthesize frc;
@synthesize sortControl;
@synthesize delegate;

- (void)viewDidLoad
{
    self.tableView.sectionIndexMinimumDisplayRowCount = 50;
    [self setupDataAccordingToDefaults];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[self.frc sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.frc sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    return [[[self.frc sections] objectAtIndex:section] name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.frc sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.frc sectionForSectionIndexTitle:title atIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodCell"];

    Food *food = [self.frc objectAtIndexPath:indexPath];
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

- (IBAction)sortControlDidChange:(id)sender {
    NSInteger index = [sender selectedSegmentIndex];
    switch(index)
    {
        case 0:
            [self setupDataSortedByName];
            [[NSUserDefaults standardUserDefaults] setObject:@"name" forKey:@"inventorySortOrder"];
            break;
        case 1:
            [self setupDataSortedByDate];
            [[NSUserDefaults standardUserDefaults] setObject:@"lastAdded" forKey:@"inventorySortOrder"];
            break;
    }
}

- (void)setupDataAccordingToDefaults
{
    NSString *sortingPreference = [[NSUserDefaults standardUserDefaults] stringForKey:@"inventorySortOrder"];
    if([sortingPreference isEqualToString:@"lastAdded"]) {
        [self setupDataSortedByDate];
        self.sortControl.selectedSegmentIndex = 1;
    } else {
        [self setupDataSortedByName];
        self.sortControl.selectedSegmentIndex = 0;
    }
}

- (void)setupDataSortedByName
{
    [self setupDataWithSortKey:@"name" ascending:YES sectionNameKeyPath:@"name.firstInitialString"];
}

- (void)setupDataSortedByDate
{
    [self setupDataWithSortKey:@"lastAdded" ascending:NO sectionNameKeyPath:nil];
}

- (void)setupDataWithSortKey:(NSString *)sortKey ascending:(BOOL)ascending sectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    NSFetchRequest *fetchRequest = [Food MR_requestAllSortedBy:sortKey ascending:ascending];
    
    self.frc = [[NSFetchedResultsController alloc]
                initWithFetchRequest:fetchRequest
                managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                sectionNameKeyPath:sectionNameKeyPath
                cacheName:nil];
    self.frc.delegate = self;
    
    NSError *error;
    [self.frc performFetch:&error];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Food *doomed = [self.frc objectAtIndexPath:indexPath];
        [doomed MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] save:NULL];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete)
    {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

- (void)viewDidUnload {
    [self setSortControl:nil];
    [super viewDidUnload];
}
@end
