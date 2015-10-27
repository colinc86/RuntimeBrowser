//
//  RTBProtocolsTVC.m
//  OCRuntime
//
//  Created by Nicolas Seriot on 27/04/15.
//  Copyright (c) 2015 Nicolas Seriot. All rights reserved.
//

#import "RTBProtocolsTVC.h"
#import "RTBProtocol.h"
#import "RTBProtocolCell.h"
#import "RTBRuntime.h"
#import "RTBListTVC.h"
#import "RTBAppDelegate.h"

@interface RTBProtocolsTVC ()
@property (nonatomic, strong) NSString *filterStringLowercase;
@end

@implementation RTBProtocolsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.protocolStubs = [[RTBRuntime sharedInstance] sortedProtocolStubs];
    
    [self setupIndexedClassStubs];
}

- (void)setupIndexedClassStubs {

    self.navigationItem.title = [NSString stringWithFormat:@"All Protocols (%lu)", (unsigned long)[self.protocolStubs count]];

    NSMutableArray *ma = [[NSMutableArray alloc] init];
    
    unichar firstLetter = 0;
    unichar currentLetter = 0;
    NSMutableArray *currentLetterProtocolStubs = [[NSMutableArray alloc] init];
    
    for(RTBProtocol *p in self.protocolStubs) {
        
        if(_filterStringLowercase != nil && [[p.protocolName lowercaseString] containsString:_filterStringLowercase] == NO) {
            continue;
        }
        
        firstLetter = [p.protocolName characterAtIndex:0];
        
        if(currentLetter == 0) {
            currentLetter = firstLetter;
        }
        
        BOOL letterChange = firstLetter != currentLetter;
        
        if(letterChange) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:currentLetterProtocolStubs
                                                          forKey:[NSString stringWithFormat:@"%c", currentLetter]];
            [ma addObject:d];
            currentLetterProtocolStubs = [[NSMutableArray alloc] init];
            currentLetter = firstLetter;
        }
        
        [currentLetterProtocolStubs addObject:p];
    }

    NSDictionary *d = [NSDictionary dictionaryWithObject:currentLetterProtocolStubs
                                                  forKey:[NSString stringWithFormat:@"%c", currentLetter]];
    [ma addObject:d];
    
    self.protocolStubsDictionaries = ma;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_protocolStubsDictionaries count] > 0 ? [_protocolStubsDictionaries count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section >= [_protocolStubsDictionaries count]) return 0;
    
    NSDictionary *d = [_protocolStubsDictionaries objectAtIndex:section];
    return [[[d allValues] lastObject] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTBProtocolCell *cell = (RTBProtocolCell *)[tableView dequeueReusableCellWithIdentifier:@"RTBProtocolCell"];

    if (!cell) {
        cell = [[RTBProtocolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RTBProtocolCell"];
    }
    
    NSDictionary *d = [_protocolStubsDictionaries objectAtIndex:indexPath.section];
    NSArray *protocols = [[d allValues] lastObject];
    
    RTBProtocol *p = [protocols objectAtIndex:indexPath.row];
    cell.protocolObject = p;
    
    return cell;
}

- (RTBProtocol *)protocolStubAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *d = [_protocolStubsDictionaries objectAtIndex:indexPath.section];
    NSArray *protocols = [[d allValues] lastObject];
    RTBProtocol *p = [protocols objectAtIndex:indexPath.row];
    return p;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RTBProtocol *p = [self protocolStubAtIndexPath:indexPath];
    
    NSArray *children = [p children];
    
    if([children count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowHeaderForProtocolNotification object:nil userInfo:[NSDictionary dictionaryWithObject:p forKey:kProtocol]];
    }
    else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        RTBListTVC *listTVC = (RTBListTVC *)[sb instantiateViewControllerWithIdentifier:@"RTBListTVC"];
        listTVC.titleForNavigationItem = p.protocolName;
        listTVC.classStubs = children;
        
        [self.navigationController pushViewController:listTVC animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the dictionary at the section index
    if(section >= [_protocolStubsDictionaries count]) return @"";
    
    NSDictionary *d = [_protocolStubsDictionaries objectAtIndex:section];
    
    NSString *letter = [[d allKeys] lastObject];
    NSUInteger i = [[[d allValues] lastObject] count];
    return [NSString stringWithFormat:@"%@ (%@)", letter, @(i)];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    NSMutableArray *ma = [[NSMutableArray alloc] init];
    
    for(NSDictionary *d in _protocolStubsDictionaries) {
        [ma addObject:[[d allKeys] lastObject]];
    }
    
    [ma sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *spacedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < ma.count; i++) {
        [spacedArray addObject:[ma objectAtIndex:i]];
        [spacedArray addObject:@""];
    }
    
    [spacedArray removeLastObject];
    
    return spacedArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index % 2 == 0) {
        return index / 2;
    }
    else {
        return -1;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText { // called when text changes (including clear)
    
    if([searchText length] > 0) {
        self.filterStringLowercase = searchText.lowercaseString;
    } else {
        self.filterStringLowercase = nil;
        
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
    }
    
    [self setupIndexedClassStubs];
}

@end
