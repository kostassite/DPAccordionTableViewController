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
-(NSInteger)tableView:(DPAccordionTableViewController*)tableView numberOfRowsInExpandedSection:(NSInteger)section;



@end


@interface DPAccordionTableViewController : UITableViewController

@property (nonatomic,weak) id<DPAccordionTableViewControllerDataSource> datasource;
@end
