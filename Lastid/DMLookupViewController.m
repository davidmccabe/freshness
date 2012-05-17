//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "DMLookupViewController.h"
#import "DMFood.h"

@interface DMLookupViewController ()
@property (strong, nonatomic) NSFetchedResultsController *frc;
@property (copy, nonatomic) NSString *searchString;
@property (copy, nonatomic) NSString *sortOrder;
@end

@implementation DMLookupViewController

@synthesize frc;
@synthesize sortControl;
@synthesize searchString;
@synthesize sortOrder;

- (void)viewDidLoad
{
    self.tableView.sectionIndexMinimumDisplayRowCount = 50;
    self.searchDisplayController.searchResultsTableView.sectionIndexMinimumDisplayRowCount = 50;
    [self setupStateFromDefaults];
}

- (void)viewDidUnload
{
    self.sortControl = nil;
    self.frc = nil;
    [super viewDidUnload];
}

#pragma mark TABLE VIEW DRECK

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

#pragma mark CONFIGURING CELLS

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FoodCell"];

    DMFood *food = [self.frc objectAtIndexPath:indexPath];
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

#pragma mark SORTING, SEARCHING, & FETCHING

+ (NSArray *)sortOrdersArray
{
    static NSArray *array = nil;
    if(array == nil) array = [NSArray arrayWithObjects:@"name", @"lastAdded", nil];
    return array;
}

- (IBAction)sortControlDidChange:(id)sender {
    self.sortOrder = [[[self class] sortOrdersArray] objectAtIndex:[sender selectedSegmentIndex]];
    [[NSUserDefaults standardUserDefaults] setObject:self.sortOrder forKey:@"inventorySortOrder"];
    [self setupFetchedResults];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)theSearchString
{
    self.searchString = theSearchString;
    [self setupFetchedResults];
    return YES;
}

- (void)setupStateFromDefaults
{
    self.sortOrder = [[NSUserDefaults standardUserDefaults] stringForKey:@"inventorySortOrder"];
    self.sortControl.selectedSegmentIndex = [[[self class] sortOrdersArray] indexOfObject:self.sortOrder];
    [self setupFetchedResults];
}

- (void)setupFetchedResults
{
    BOOL isSortedByName = [self.sortOrder isEqualToString:@"name"];

    NSFetchRequest *fetchRequest;
    if(self.searchString == nil || [self.searchString isEqualToString:@""]) {
        fetchRequest = [DMFood MR_requestAllSortedBy:self.sortOrder ascending:isSortedByName];        
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", self.searchString];
        fetchRequest = [DMFood MR_requestAllSortedBy:self.sortOrder ascending:isSortedByName withPredicate:predicate];
    }
    
    self.frc = [[NSFetchedResultsController alloc]
                initWithFetchRequest:fetchRequest
                managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                sectionNameKeyPath:isSortedByName ? @"name.firstInitialString" : nil
                cacheName:nil];
    self.frc.delegate = self;
    
    NSError *error;
    [self.frc performFetch:&error];
    [self.tableView reloadData];
}


#pragma mark DELETION

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DMFood *doomed = [self.frc objectAtIndexPath:indexPath];
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

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{    
    if (type == NSFetchedResultsChangeDelete)
    {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

@end
