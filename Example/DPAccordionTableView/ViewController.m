//
//  ViewController.m
//  DPAccordionTableView
//
//  Created by Kostas Antonopoulos on 9/30/12.
//  Copyright (c) 2012 Kostas Antonopoulos. All rights reserved.
//

#import "ViewController.h"
#import "DPAccordionTableViewController.h"

@interface ViewController ()<DPAccordionTableViewControllerDataSource,DPAccordionTableViewControllerDelegate>{
    DPAccordionTableViewController *accordionTableViewController;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    accordionTableViewController=[[DPAccordionTableViewController alloc]init];
    [accordionTableViewController.view setFrame:CGRectMake(0, 0, 320, 400)];

    [accordionTableViewController setDelegate:self];
    [accordionTableViewController setDatasource:self];
    

    [self.view addSubview:accordionTableViewController.view];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DPAccordionTableViewControllerDataSource

-(NSInteger)numberOfSectionsInAccordionTableView:(UITableView*)tableView{
    return 5;
}

-(NSInteger)accordionTableView:(UITableView*)tableView numberOfRowsInExpandedSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)accordionTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AccordionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"Row %ld",(long)indexPath.row]];
    // Configure the cell...
    
    return cell;
}
#pragma mark - DPAccordionTableViewControllerDelegate

-(UIView*)accordionTableView:(UITableView *)tableView headerViewForSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];

    [titleLabel setText:[NSString stringWithFormat:@"Custom Section %ld",(long)section]];
    [view addSubview:titleLabel];
    
    return view;
}
@end
