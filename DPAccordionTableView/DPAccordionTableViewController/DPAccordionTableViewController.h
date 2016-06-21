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
-(CGFloat)accordionTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;


-(void)accordionTableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

-(void)accordionTableView:(UITableView *)tableView willOpenSection:(NSInteger)section;
-(void)accordionTableView:(UITableView *)tableView willCloseSection:(NSInteger)section;

-(void)accordionTableView:(UITableView *)tableView didOpenSection:(NSInteger)section;
-(void)accordionTableView:(UITableView *)tableView didCloseSection:(NSInteger)section;

-(BOOL)accordionTableView:(UITableView *)tableView shouldOpenSection:(NSInteger)section;
-(BOOL)accordionTableView:(UITableView *)tableView shouldCloseSection:(NSInteger)section;

@end

@interface DPAccordionTableViewController : UIViewController

@property (nonatomic,weak) id<DPAccordionTableViewControllerDataSource> datasource;
@property (nonatomic,weak) id<DPAccordionTableViewControllerDelegate> delegate;

@property (nonatomic) NSInteger openSection; //set NSNotFound to close all sections
@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic) CGFloat tableHeaderHeight;
@end
