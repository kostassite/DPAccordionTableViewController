//
//  DPAccordionTableViewController.h
//  DPAccordionTableView
//
//  Created by Kostas Antonopoulos on 9/30/12.
//  Copyright (c) 2012 Kostas Antonopoulos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPAccordionTableViewController;

@protocol DPAccordionTableViewControllerDataSource <NSObject>

@required
-(NSInteger)numberOfSectionsInAccordionTableView:(UITableView*)tableView;
-(NSInteger)accordionTableView:(UITableView*)tableView numberOfRowsInExpandedSection:(NSInteger)section;

-(UITableViewCell*)accordionTableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;

@optional
-(NSString*)accordionTableView:(UITableView*)tableView titleForSection:(NSInteger)section;

@end

@protocol DPAccordionTableViewControllerDelegate <NSObject>

@optional
-(UIView*)accordionTableView:(UITableView*)tableView headerViewForSection:(NSInteger)section;
-(void)accordionTableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface DPAccordionTableViewController : UIViewController

@property (nonatomic,weak) id<DPAccordionTableViewControllerDataSource> datasource;
@property (nonatomic,weak) id<DPAccordionTableViewControllerDelegate> delegate;
@end
