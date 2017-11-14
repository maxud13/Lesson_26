//
//  ViewController.m
//  Lesson_26
//
//  Created by maxud on 10.11.2017.
//  Copyright © 2017 lesson_1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *someArray;
@property (nonatomic, strong)NSMutableArray *searchArray;

@property (nonatomic, assign)BOOL isSearchMode;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.someArray = [NSMutableArray new];
    self.searchArray = [NSMutableArray new];
    
    for (NSInteger i = 0; i < 300;i++)
    {
        NSString *str = [NSString stringWithFormat:@"str %lu",i+1];
        [self.someArray addObject:str];
    }
    
    [self createSomeFile];
    [self readFromFile];
    [self veryfyEmail:@"Some.em@gh.oppa"];
    [self verifyPassword:@"1gfh23"];
}

-(void)createSomeFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *pathDirectory = path.firstObject;
    
    NSString *someText = @"1/n2/n3/n5";
    
    NSError *error = nil;
    
    NSString *pathWithFileName = [pathDirectory stringByAppendingPathComponent:@"someFile.txt"];
    
    BOOL succes = [someText writeToFile:pathWithFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    NSString *result = succes ? @"File Saved Succes" : @"Error create file";
    
    NSLog(@"%@", result);
}

-(void)readFromFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *pathDirectory = path.firstObject;
    
    NSString *pathWithFileName = [pathDirectory stringByAppendingPathComponent:@"someFile.txt"];

    
    NSError *error = nil;
    
    NSString *textFromFile = [NSString stringWithContentsOfFile:@"" encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"%@",textFromFile);
}

-(void)veryfyEmail:(NSString*)email
{
    if (email.length == 0)
    {
        return;
    }
    
    NSError *error = nil;
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger regMatches = [regExp numberOfMatchesInString:email options:0 range:NSMakeRange(0, email.length)];
    
    NSLog(@"%lu", (unsigned long)regMatches);
    
    if (regMatches == 0)
    {
        NSLog(@"Email not valid");
    } else {
        NSLog(@"Email valid");
    }
}

-(void)verifyPassword:(NSString*)password
{
    if (password.length == 0)
    {
        return;
    }
    
    NSError *error = nil;
    
    NSString *regExPattern = @"[A-Za-z0-9]{4-8}]";
    
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger regMatches = [regExp numberOfMatchesInString:password options:0 range:NSMakeRange(0, password.length)];
    
    NSLog(@"%lu", (unsigned long)regMatches);
    
    if (regMatches == 0)
    {
        NSLog(@"Password not valid");
    } else {
        NSLog(@"Password valid");
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isSearchMode ? self.searchArray.count : self.someArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.isSearchMode ? self.searchArray[indexPath.row] : self.someArray[indexPath.row];
    return cell;
}

-(void)searchText
{
    NSString *searchText = self.searchBar.text;
    NSPredicate *presicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchText];
    self.searchArray = [NSMutableArray arrayWithArray:[self.someArray filteredArrayUsingPredicate:presicate ]];
}
#pragma mark - Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.isSearchMode = YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange");
    
    [self.searchArray removeAllObjects];
    
    if([searchText length] != 0)
    {
        self.isSearchMode = YES;
        [self searchText];
    }
    else {
        self.isSearchMode = NO;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarCancelButtonClicked");
    self.isSearchMode = NO;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing");
    self.isSearchMode = NO;
    [self.tableView reloadData];
}


@end
