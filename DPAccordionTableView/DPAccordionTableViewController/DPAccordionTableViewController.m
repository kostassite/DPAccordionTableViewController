//
//  DPAccordionTableViewController.m
//  DPAccordionTableView
//
//  Created by Kostas Antonopoulos on 9/30/12.
//  Copyright (c) 2012 Kostas Antonopoulos. All rights reserved.
//

#import "DPAccordionTableViewController.h"

@interface DPAccordionTableViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger openSection;
    IBOutlet UITableView *tableView;
}

@end

@implementation DPAccordionTableViewController
@synthesize datasource;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    openSection=NSNotFound;


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView reloadData];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.datasource numberOfSectionsInAccordionTableView:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==openSection) {
        return [self.datasource accordionTableView:self numberOfRowsInExpandedSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccordionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"Row %d",indexPath.row]];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header;
    if (self.delegate && [self.delegate respondsToSelector:@selector(accordionTableView:headerViewForSection:)]) {
        header = [self.delegate accordionTableView:self headerViewForSection:section];
    }else{
        header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
        
        if ([self.datasource respondsToSelector:@selector(accordionTableView:titleForSection:)]) {
            [titleLabel setText:[self.datasource accordionTableView:self titleForSection:section]];
        }else{
            [titleLabel setText:[NSString stringWithFormat:@"Section %d",section]];
        }
        [header addSubview:titleLabel];
    }

    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapped:)];
    [header addGestureRecognizer:tapRecognizer];

    header.tag=section;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - Header Actions

-(void)headerTapped:(UITapGestureRecognizer*)sender{
    if (openSection!=sender.view.tag) { //einai kleisto
        [self openSection:sender.view.tag];
    }else{
        [self closeSection:sender.view.tag];
    }
    
}

#pragma mark - Open/Close TableView

-(void)openSection:(NSInteger)section{
    //close previous open rows
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
     if (openSection != NSNotFound) {
        for (NSInteger i = 0; i < [self.datasource accordionTableView:self numberOfRowsInExpandedSection:openSection]; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:openSection]];
        }
    }
    //open new rows
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.datasource accordionTableView:self numberOfRowsInExpandedSection:section]; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (section == NSNotFound || section < openSection) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
   
    openSection=section;
    // Apply the updates.
    [self.view setUserInteractionEnabled:NO];
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [tableView endUpdates];

    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.view setUserInteractionEnabled:YES];
}

-(void)closeSection:(NSInteger)section{
    //close open rows
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    if (openSection != NSNotFound) {
        for (NSInteger i = 0; i < [self.datasource accordionTableView:self numberOfRowsInExpandedSection:section]; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
    }
    
    openSection=NSNotFound;
    // Apply the updates.
    [self.view setUserInteractionEnabled:NO];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    [tableView endUpdates];
    
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.view setUserInteractionEnabled:YES];
}

@end
