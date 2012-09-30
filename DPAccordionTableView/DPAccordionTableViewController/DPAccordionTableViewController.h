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
-(NSInteger)numberOfSectionsInAccordionTableView:(DPAccordionTableViewController*)tableView;
-(NSInteger)accordionTableView:(DPAccordionTableViewController*)tableView numberOfRowsInExpandedSection:(NSInteger)section;

@optional
-(NSString*)accordionTableView:(DPAccordionTableViewController*)tableView titleForSection:(NSInteger)section;

@end

@protocol DPAccordionTableViewControllerDelegate <NSObject>

@optional
-(UIView*)accordionTableView:(DPAccordionTableViewController*)tableView headerViewForSection:(NSInteger)section;


@end

@interface DPAccordionTableViewController : UIViewController

@property (nonatomic,weak) id<DPAccordionTableViewControllerDataSource> datasource;
@property (nonatomic,weak) id<DPAccordionTableViewControllerDelegate> delegate;
@end
